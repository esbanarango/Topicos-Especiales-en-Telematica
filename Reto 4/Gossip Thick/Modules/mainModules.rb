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
        system "clear"
        puts "\tWelcome to Gossip Chat and thank you for use our service.!"
        puts "\tType "+amarillo('-help')+" to see the avalible commands"
        print "\t-> "
        begin
          while not STDIN.eof?
            line = STDIN.gets.chomp
            if line == "-HELP" || line == "-help"
                helpUser
            elsif line == "QUIT" || line == "quit"
                exit
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
                                
                               data = {"user_id" => @user_id,
                                        "room_id" => @current_room_id,
                               }
                               getData('/API/rooms/join',data,true)
                               receiveMessageThread = Thread.new { receiveMessage }
                               insideChannelThread = Thread.new { insideChannel }
                               receiveMessageThread.join
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

    def insideChannel
        print "\t-> "
        begin
          while not STDIN.eof?
                line = STDIN.gets.chomp
                if line == "QUIT" || line == "quit"
                    exit
                else
                    data = {    "message[user_id]"                => @user_id,
                                "message[room_id]"                => @current_room_id,
                                "message[content]"                => line
                    }
                    sendMessage(data)
                    print "\t-> " 
                end
          end
        rescue SystemExit, Interrupt
            data = {    "user_id" => @user_id,
                        "room_id" => @current_room_id,
                    }
            getData('/API/rooms/leave',data,true)
            Thread.list.each { |t| t.kill }
        rescue Exception => e
          puts "Ha ocurrido un error: #{e}"      
        end
    end

    def sendMessage(data)
        postData("/API/messages",data,true)
    end

    def receiveMessage
        begin
            loop do
                msgs = getData('rooms/#{@current_room_id}/messages',"",true)
                msgs.each_with_index do |msg,i|
                    puts rojo(msg["user_id"].to_s)+":"+msg["content"] if msg["id"]>@lastMessage
                    if (i == (msgs.length - 1) )
                        @lastMessage=msg[:id]
                    end
                end
                sleep(2)
            end
        rescue Exception => e
          puts "Ha ocurrido un error: #{e}"      
        end
    end



end