=begin
    Archivo: mainModules.rb
    Topicos Especiales en Telematica, Mayo 2012
        Cliente Grueso, Gossip Chat

            Esteban Arango Medina
            Sebastian Duque Jaramillo
            Daniel Julian Duque Tirado
=end

#Expresiones regulares para los mensajes proveninetes del los usuarios
RegUserActions = %r{(?<cdg>(?i)LIST CHANNELS|JOIN CHANNEL|RESP CONVER) *(?<chnls>\(.{1,}\))?}
RegResps = %r{(Y|y|S|s|Yes|YES|yes|YeS|yEs|si|Si|sI)}


module Main

    def main
        welcome
        begin
          while not STDIN.eof?
            line = STDIN.gets.chomp
            if line == "-HELP" || line == "-help"
                helpUser
                print "\t-> "
            elsif line == "QUIT" || line == "quit"
                if(@connected)
                    leave_channel
                    welcome
                else
                    exit
                end
            elsif @connected
                insideChannel(line)
            else
                r = RegUserActions.match(line)
                if !(r.nil?)
                    code = r[:cdg]
                    code.upcase!
                    case code
                        when "LIST CHANNELS"
                           @channels = getData("/API/rooms","",true)                
                           @channels.each { |channel|  
                                puts "\t => "+verde(channel['name'])
                           }
                           print "\t-> "
                        when "JOIN CHANNEL"
                            unless r[:chnls].nil?
                                joinChannelName = r[:chnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
                                @channels.each { |channel|  
                                    if channel['name'] == joinChannelName
                                        @current_room_id = channel['id']
                                        break
                                    end
                               }
                               if(@current_room_id == 0)
                                    puts rojo("\tRoom not found.")
                                    print "\t-> "
                               else
                                    data = {"user_id" => @user_id,
                                        "room_id" => @current_room_id
                                    }
                                    jsonResponse =   getData('/API/rooms/join',data,true)  
                                    #If there is a 'response' key in the hash, then everything went well.
                                    if jsonResponse['response']
                                        system "clear"
                                        @connected= true
                                        puts("Your now in Room: "+verde("#{joinChannelName}")+".")
                                    else
                                        @current_room_id = 0
                                        puts(rojo("\tServer Error:")+" Sorry apparently there was an error with the server.")
                                        puts("\t\tTry again in a while.")
                                     end 
                                end
                            else
                                system "clear"
                                puts rojo("\tInvalid command")
                                puts amarillo("\tDid you mean?")+" -> "+verde("'JOIN CHANNEL (channel_name)'")
                                puts "\tType "+amarillo('-help')+" to see the avalible commands"
                                print "\t-> " 
                            end 
                    end
                else
                    system "clear"
                    puts amarillo("\tCommand not found")
                    puts "\tType "+amarillo('-help')+" to see the avalible commands"
                    print "\t-> " 
                end
            end
          end
        rescue SystemExit, Interrupt
            puts("Good Bye! :).")
            Thread.list.each { |t| t.kill }
        rescue Exception => e
          puts "Ha ocurrido un error: #{e}"      
        end
    end

    def welcome
        system "clear"
        puts "\tWelcome to Gossip Chat and thank you for use our service.!"
        puts "\tType "+amarillo('-help')+" to see the avalible commands"
        puts "\tThese are the available rooms:!"
        @channels = getData("/API/rooms","",true)                
        @channels.each { |channel| 
            puts "\t => "+verde(channel['name'])
        }
        print "\t-> "
    end

    def leave_channel
        data = {    "user_id" => @user_id,
                            "room_id" => @current_room_id,
                        }
        getData('/API/rooms/leave',data,true)
        @current_room_id = 0
        @connected = false
    end

    def insideChannel(line)
        data = {    "message[user_id]"                => @user_id,
                    "message[room_id]"                => @current_room_id,
                    "message[content]"                => line
                }
        if line.gsub(/\s+/, " ").strip != ""
            sendMessage(data)
        end
    end

    def sendMessage(data)
        postData("/API/messages",data,true)
    end

    def receiveMessage
        while true
            if(@connected)
                msgs = getData("/rooms/#{@current_room_id}/messages","",true)
                msgs.each_with_index do |msg,i|
                    if msg["id"]>@lastMessage and @newInTheChannel
                        if !@users.has_key?(msg["user_id"])
                            newUser = getData("/API/users/#{msg['user_id']}","",true)
                            @users[msg["user_id"]] = newUser["response"]["username"]
                        end
                        puts rojo(@users[msg["user_id"]])+":"+msg["content"]
                        @lastMessage=msg["id"]
                    elsif msg["id"]>@lastMessage and msg["user_id"] != @user_id
                        if !@users.has_key?(msg["user_id"])
                            newUser = getData("/API/users/#{msg['user_id']}","",true)
                            @users[msg["user_id"]] = newUser["response"]["username"]
                        end
                        puts verde(@users[msg["user_id"]])+":"+msg["content"]
                        @lastMessage=msg["id"]
                    end
                end
                @newInTheChannel=false
            end
            sleep(1)
        end
    end



end