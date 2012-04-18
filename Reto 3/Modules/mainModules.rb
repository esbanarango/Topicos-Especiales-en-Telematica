=begin
	Archivo: AdFuente.rb
	Topicos Especiales en Telematica, Abril 2012
		Implementación de un servicio de presencia

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end

#Expresiones regulares para los mensajes proveninetes del los usuarios
RegUserActions = %r{(?<cdg>(?i)LIST USERS|CHAT|QUIT CONVERSATION|QUIT APP) ?(?<user>\(.{1,}\))?}
RegResps = %r{(Y|y|S|s|Yes|YES|yes|YeS|yEs|si|Si|sI)}


module Main
	# ---------- MAIN  ----------
	def mainADMIN(socket)
		while not socket.eof?
            line = socket.readline.chomp
            r = RegUserActions.match(line)
            unless r.nil?
                code = r[:cdg]
                code.upcase!
                case code
                    when "QUIT CONVERSATION"
                        userName = r[:user].to_s.sub!(/\(/,'').sub!(/\)/,'')
                        @users.keys.each do |user|
                            if(user.userName == userName)
                                user.state = 'Online'
                                @users[user].puts ("You have just left you last conversation.")
                                @users[user].puts amarillo("Type '-help' to see the avalible commands")
                                messagesOffline(userName)
                            end
                    end
                    when "QUIT APP"
                        userName = r[:user].to_s.sub!(/\(/,'').sub!(/\)/,'')
                        @users.keys.each do |user|
                            if(user.userName == userName)
                                user.state = 'Offline'
                            end
                    end
                    when "LIST USERS"
                        socket.puts gris("Online users:")
                        @users.keys.each do |user|  
                            socket.puts verde("\t #{user.userName}") if user.state == "Online"
                        end
                        socket.puts gris("Busy users:")
                        @users.keys.each do |user|
                            socket.puts amarillo("\t #{user.userName}") if user.state == "Busy"
                        end
                        socket.puts gris("Offline users:")
                        @users.keys.each do |user|
                            socket.puts azul("\t #{user.userName}") if user.state == "Offline"
                        end
                        socket.puts "\n"
                    when "CHAT" 
                        userName = r[:user].to_s.sub!(/\(/,'').sub!(/\)/,'')

                        #Flags decisiones importantes
                        existe=false
                        messages=false

                        userConectTo= @users.invert[socket] #My information
                        uriUserConectTo = userConectTo.uri
                        #Verificar que no sea el mismo
                        if userConectTo.userName == userName
                            socket.puts ("You can not chat with yourself!.")   
                        else
                            @users.keys.each do |user|
                                if(user.userName == userName) 
                                    existe=true
                                    if(user.state == 'Online')
                                    	socket.puts ("Waiting for #{userName} responses...")
                                    	#Pregunto primero si el otro peer si desea 'chatiar' conmigo
                                    	@users[user].puts ("User #{userConectTo.userName} wants to chat with you.")
                                        @users[user].puts ("Would you like too?(Y/N)\n")
                                            
                                    	resp = @users[user].readline.chomp
                                        #puts ("Pillatea: "+resp)
    									if resp=~RegResps
    										@users[user].puts("NEW CONECTION #{uriUserConectTo}")     #El se conecta conmigo
    										@users[user].puts @time.strftime("%Y-%m-%d %H:%M:%S")     #Muestro el tiempo de la conversación
                                            @users[user].puts("Your now connected with "+verde("#{userConectTo.userName}")+".")
    	                                    socket.puts ("NEW CONECTION #{user.uri}")                 #Me conecto con el 
    	                                    socket.puts @time.strftime("%Y-%m-%d %H:%M:%S")
                                            socket.puts ("Your now connected with "+verde("#{userName}")+".")
    	                                    user.state = userConectTo.state ='Busy'
    									else
    										socket.puts ("User "+verde("#{userName}")+" does not want to chat with you.")
    									end
                                    elsif (user.state == 'Busy')
                                       socket.puts ("User "+verde("#{userName}")+" is busy at this moment, you may interrupt.")
                                       messages=true
                                    else
                                       socket.puts ("User "+verde("#{userName}")+" is offline at this moment.")
                                       messages=true
                                    end  
                                    break   #Lo encontré me salgo el for                                       
                                end
                            end
                            if(messages)
                                leaveMessages(socket,userConectTo.userName,userName)
                            end
                            if(!existe)
                                socket.puts "User #{userName} does not exist!."
                            end 
                        end                                    
                end#case
            else
                socket.puts "ERR 1"
            end
        end#while
	end
end