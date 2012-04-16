=begin
	Archivo: AdFuente.rb
	Topicos Especiales en Telematica, Abril 2012
		Implementación de un servicio de presencia

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end

#Expresiones regulares para los mensajes proveninetes del los usuarios
RegUserActions = %r{(?<cdg>(?i)LIST USERS|CHAT|QUIT CONVERSATION) ?(?<user>\(.{1,}\))?}


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
                        #Verificar que no sea el mismo
                        userName = r[:user].to_s.sub!(/\(/,'').sub!(/\)/,'')
                        existe=false
                        userConectTo= @users.invert[socket] #My information
                        uriUserConectTo = userConectTo.uri
                        @users.keys.each do |user|
                            if(user.userName == userName) 
                                existe=true
                                if(user.state == 'Online')
                                	socket.puts ("Waiting for #{userName} responses...")
                                	#Pregunto primero si el otro peer si desea 'chatiar' conmigo
                                	@users[user].puts ("User #{userConectTo.userName} wants to chat with you.\nWould you like too?(Y/N)")
                                	resp = @users[user].readline.chomp
                                    #puts ("Pillatea: "+resp)
									if(resp == 'Y' || resp == 'y')
										@users[user].puts("NEW CONECTION #{uriUserConectTo}")    #El se conecta conmigo
										@users[user].puts("Your now connected with "+verde("#{userConectTo.userName}")+".")
	                                    socket.puts ("NEW CONECTION #{user.uri}")                 #Me conecto con el 
	                                    socket.puts ("Your now connected with "+verde("#{userName}")+".")
	                                    user.state = userConectTo.state ='Busy'
									else
										socket.puts ("User #{userName} does not want to chat with you.")							
										break
									end
                                elsif (user.state == 'Busy')
                                   socket.puts "User #{userName} is busy at this moment, you may interrupt."
                                else
                                   socket.puts "User #{userName} is offline at this moment."
                                end                                            
                            end
                        end
                        if(!existe)
                            socket.puts "User #{userName} does not exist!."
                        end                                     
                end#case
            else
                socket.puts "ERR 1"
            end
        end#while
	end	

end