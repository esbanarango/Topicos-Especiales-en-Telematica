=begin
	Archivo: AdFuente.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end

#Expresiones regulares para los mensajes proveninetes del AdFuente, AdCliente y Admin
RegAdFuente = %r{(?<cdg>(?i)LIST CH|QUIT|NEWMSG) ?(?<cnls>\(.{1,}\))? ?(?<msg>.*)?}
RegAdCliente = %r{(?<cdg>(?i)LIST CH|QUIT|LIST MY CH|SUBSCRIBE|UNSUBSCRIBE|GETMSGS) ?(?<cnls>\(.{1,}\))?}
RegAdmin = %r{(?<cdg>(?i)LIST CH|QUIT|LIST CLIENTS|NEW CH|REMOVE CH|-HELP) ?(?<cnls>\(.{1,}\))?}

module Main
# ---------- MAIN ADFUENTE ----------
def mainAdFuente(socket)
	begin
		while not socket.eof?
			line = socket.readline.chomp
			r = RegAdFuente.match(line)
			unless r.nil?
				case r[:cdg]
		    		when "LIST CH", "list ch"					#Listar los canales existentas al AdFuente
			    		socket.puts gris("Actual channels:")
			    		@canales.keys.each do |canal|
			    			socket.puts rojo("\t- #{canal}")	
			    		end
			    		socket.puts "\n"
			    	when "NEWMSG", "newmsg"					#Nuevo mensaja para uno o muchos canales
			    		#Validaciones
			    		if r[:cnls].to_s.empty?
			    			socket.puts "ERR 2"	
			    		elsif r[:msg].to_s.empty?
			    			socket.puts "ERR 3"
			    		else
			    			mensajeMSG = r[:msg].to_s
			    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')			    			
			    			asCanales = canalesMSG.split(',')
			    			asCanales.each do |canal|
			    				canal = canal.strip.upcase
			    				if @canales.has_key?(canal) 
			    					@canales[canal][0].push(mensajeMSG)
			    					#Envio del mensaje a los clientes 'suscritos a este canal'
			    					@canales[canal][1].each do |cliente|
			    						if	@clientes.include?(cliente)
			    							@clientes[cliente].puts gris("A new message from channel ")+rojo(canal)+verde("\n\t-> ")+mensajeMSG
			    							socket.puts gris("Message sent to channel")+rojo("->")+canal
			    						end
			    					end
			    				end
			    			end

			    		end							
			    end#case
			else
				socket.puts "ERR 1"
			end
		end#while
	rescue Exception => e
		puts "An exception has occurred: #{e}"
	ensure	
		@fuentes.delete(socket)								#Eliminamos del array
	end
end	

# ---------- MAIN ADCLIENTE ----------
def mainAdCliente(socket)
	#Ver los mensajes de un canal () socket.puts @canales[line][0]
	begin
		while not socket.eof?
			line = socket.readline.chomp
			r = RegAdCliente.match(line)
			unless r.nil?
				case r[:cdg]
		    		when "LIST CH", "list ch"					#Listar los canales existentas al AdFuente
			    		socket.puts gris("Actual channels:")
			    		@canales.keys.each do |canal|
			    			socket.puts rojo("\t- #{canal}")	
			    		end
			    		socket.puts "\n"
			    	when "LIST MY CH", "list my ch"					#Listar los canales en los que me encuentro suscrito
			    		nombreUsuario = @clientes.invert[socket]
			    		socket.puts gris("Your channels:")
			    		@canales.each do |k,v|
			    			if v[1].include?(nombreUsuario)
			    				socket.puts rojo("\t- #{k}")	
			    			end
			    		end
			    		socket.puts "\n"
			    	when "GETMSGS", "getmsgs"					#Nuevo mensaja para uno o muchos canales
				    	#Validaciones
			    		if r[:cnls].to_s.empty?
			    			socket.puts "ERR 2"	
			    		else
			    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
			    			asCanales = canalesMSG.split(',')
			    			asCanales.each do |canal|
			    				canal = canal.strip.upcase
			    				if @canales.has_key?(canal.upcase)
			    					if @canales[canal][0].empty?
			    						socket.puts gris("There are no messages on channel ")+rojo(canal)
			    					else
				    					socket.puts gris("Messages from channel ")+rojo(canal) 
				    					@canales[canal][0].each do |mensaje|
				    						socket.puts verde("\t\t-> ")+gris(mensaje)
				    					end
				    				end
			    				else
			    					socket.puts amarillo("Channel ")+rojo("#{canal.upcase}")+amarillo(" does not exist")
			    				end
			    			end	
			    		end
			    	when "SUBSCRIBE", "subscribe"
			    		#Validaciones
			    		if r[:cnls].to_s.empty?
			    			socket.puts "ERR 2"
			    		else
			    			nombreUsuario = @clientes.invert[socket]
			    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
			    			asCanales = canalesMSG.split(',')
			    			asCanales.each do |canal|
			    				canal = canal.strip.upcase
			    				if @canales.has_key?(canal) && !@canales[canal][1].include?(nombreUsuario)
			    					socket.puts gris("Successfully ")+verde("subscribed ")+gris("to channel")+verde(" -> ")+rojo(canal)
			    					@canales[canal][1].push(nombreUsuario)
			    				elsif @canales[canal][1].include?(nombreUsuario)
			    					socket.puts gris("You are ")+verde("already subscribed ")+gris("to channel")+verde(" -> ")+rojo(canal)	
			    				end	
			    			end	
			    		end
			    	when "UNSUBSCRIBE", "unsubscribe"
			    		#Validaciones
			    		if r[:cnls].to_s.empty?
			    			socket.puts "ERR 2"
			    		else
			    			nombreUsuario = @clientes.invert[socket]
			    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
			    			asCanales = canalesMSG.split(',')
			    			asCanales.each do |canal|
			    				canal = canal.strip.upcase
			    				if @canales.has_key?(canal) && @canales[canal][1].include?(nombreUsuario)
			    					socket.puts gris("Successfully ")+rojo("unsubscribed ")+gris("from channel")+verde(" -> ")+rojo(canal)
			    					@canales[canal][1].delete(nombreUsuario)
			    				elsif !@canales[canal][1].include?(nombreUsuario)
			    					socket.puts gris("You are ")+rojo("not subscribed ")+gris("to channel")+verde(" -> ")+rojo(canal)
			    				end	
			    			end	
			    		end		
			    end#case
			else
				socket.puts "ERR 1"
			end
		end#while
	rescue Exception => e
		puts "An exception has occurred: #{e}"
	ensure	
		@clientes.delete_if {|k,v| v == socket}			#Eliminamos cliente dle hash
	end
	
end	

def mainADMIN()
	begin
      while not STDIN.eof?
        line = STDIN.gets.chomp
        r = RegAdmin.match(line)			#(?<cdg>LIST CH|LIST CLIENTS|NEW CH|REMOVE CH) ?(?<cnls>\(.{1,}\))?
		unless r.nil?
	      	case r[:cdg]
	      		when "LIST CH", "list ch"
	      			puts gris("Actual channels:")
		    		@canales.keys.each do |canal|
		    			puts rojo("\t- #{canal}")	
		    		end
		    		puts "\n"
	      		when "LIST CLIENTS", "list clients"
	      			puts gris("Online clients:")
	      			@clientes.keys.each do |cliente|
		    			puts rojo("\t- #{cliente}")	
		    		end
	      			puts "\n"
	      		when "NEW CH", "new ch"
	      			if r[:cnls].to_s.empty?
		      			puts amarillo("You have not entered any channel |Type '-HELP'|")
			    	else				    		
		    			canalMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
		    			asCanal = canalMSG.split(',')
		    			if asCanal.size > 1
		    				puts amarillo("Only one channel at a time")
		    			elsif @canales.include?(canalMSG.upcase)
		    					puts "Channel #{canalMSG} already exists."
		    			else 
		    				@canales[canalMSG.upcase] = [[],[]]
		    				puts gris("Successfully created channel")+verde(" -> ")+"#{canalMSG}"
		    			end
			    	end
	      		when "REMOVE CH", "remove ch"
	      			if r[:cnls].to_s.empty?
		      			puts "You have not entered any channel |Type '-HELP'|"
			    	else
		    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
		    			asCanales = canalesMSG.split(',')
		    			asCanales.each do |canal|
		    				canal = canal.strip.upcase
		    				if @canales.has_key?(canal)
		    					@canales.delete(canal)
		    					puts gris("Successfully removed channel")+verde(" -> ")+"#{canal}"
		    				else
		    					puts "Channel -> #{canal} does not exist"
		    				end	
		    			end	
			    	end
			    when "-HELP", "-help"
			    		helpAdmin
			    when "QUIT"
			    	exit
			end#case
		else
			puts amarillo("Command not found")
		end
      end
    rescue SystemExit, Interrupt
	    puts("Good Bye :).")
		guardarInfo()
		Thread.list.each { |t| t.kill }
    rescue Exception => e
      puts "An exception has occurred: #{e}"
    end
end
	
end