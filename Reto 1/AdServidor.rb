=begin
	Archivo: AdServidor.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Daniel Julian Duque Tirado
			Sebastian Duque Jaramillo
=end
require "socket"
require 'nokogiri'
require 'readline'

#Expresiones regulares para los mensajes proveninetes del AdFuente, AdCliente y Admin
RegAdFuente = %r{(?<cdg>LIST CH|NEWMSG) ?(?<cnls>\(.{1,}\))? ?(?<msg>.*)?}
RegAdCliente = %r{(?<cdg>LIST CH|SUBSCRIBE|GETMSGS) ?(?<cnls>\(.{1,}\))?}
RegAdmin = %r{(?<cdg>LIST CH|LIST CLIENTS|NEW CH|REMOVE CH) ?(?<cnls>\(.{1,}\))?}

class AdServidor
	attr_accessor :puerto,:canales,:fuentes,:clientes, :doc

	$formatoNEWCHN = "Format: NEW CH (channel1) \nOr type -HELP"
	$formatoREMOVECHN = "Format: REMOVE CH (channel1,...) \nOr type -HELP"

	def initialize(puerto=1212)
		@puerto = puerto
		@fuentes = []
		@canales = {}							#Creación del Hash de canales
		@clientes = {}
		@doc = Nokogiri::XML File.open 'data.xml'	
		cargarInfoXML('canales')				  #Cargamos los canales del XML
		cargarInfoXML('mensajes')				  #Cargamos los mensajes del XML
	end

	def run
		puts "Server running..."
		
		hiloAdministrador = Thread.new {mainADMIN}

		Socket.tcp_server_loop(@puerto) {|socket, client_addrinfo|
		  Thread.new {
		    begin
		    	identificacion(socket, client_addrinfo)	    
		    	if @fuentes.include?(socket)
		    		mainAdFuente(socket)		   #Main principal de las acciones del AdFuente
		    	else
		    		mainAdCliente(socket)		   #Main principal de las acciones del AdCliente
				end
			ensure
		      socket.close 
		    end
		  }
		}
	end

	private

	# ---------- MAIN ADFUENTE
	def mainAdFuente(socket)
		begin
			while not socket.eof?
				line = socket.readline.chomp
				r = RegAdFuente.match(line)
				unless r.nil?
					case r[:cdg]
			    		when "LIST CH"					#Listar los canales existentas al AdFuente
				    		socket.puts "Actual channels:"
				    		socket.puts @canales.keys
				    		socket.puts "\n"
				    	when "NEWMSG"					#Nuevo mensaja para uno o muchos canales
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
				    							@clientes[cliente].puts "A new message from channel #{canal}\n   ->#{mensajeMSG}"
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

	# ---------- MAIN ADCLIENTE
	def mainAdCliente(socket)
		#Ver los mensajes de un canal () socket.puts @canales[line][0]
		begin
			while not socket.eof?
				line = socket.readline.chomp
				r = RegAdCliente.match(line)
				unless r.nil?
					case r[:cdg]
			    		when "LIST CH"					#Listar los canales existentas al AdFuente
				    		socket.puts "Actual channels:"
				    		socket.puts @canales.keys
				    		socket.puts "\n"
				    	when "GETMSGS"					#Nuevo mensaja para uno o muchos canales
					    	#Validaciones
				    		if r[:cnls].to_s.empty?
				    			socket.puts "ERR 2"	
				    		else
				    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
				    			asCanales = canalesMSG.split(',')
				    			asCanales.each do |canal|
				    				canal = canal.strip.upcase
				    				if @canales.has_key?(canal.upcase) 
				    					socket.puts "Messages from channel #{canal}:\n"
				    					@canales[canal][0].each do |mensaje|
				    						socket.puts "   ->#{mensaje}\n"
				    					end
				    				end
				    			end	
				    		end
				    	when "SUBSCRIBE"
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
				    					socket.puts "Successfully subscribed to channel -> #{canal}\n"
				    					@canales[canal][1].push(nombreUsuario)
				    				elsif @canales[canal][1].include?(nombreUsuario)
				    					socket.puts "You are already subscribed to channel -> #{canal}\n"
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
		      		when "LIST CH"
		      			puts "Actual channels:"
		      			puts @canales.keys
		      			puts "\n"
		      		when "LIST CLIENTS"
		      			puts "Online clients:"
		      			puts @clientes.keys
		      			puts "\n"
		      		when "NEW CH"
		      			if r[:cnls].to_s.empty?
			      			puts $formatoNEWCHN
				    	else
			    			canalMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
			    			asCanal = canalMSG.split(',')
			    			if asCanal.size > 1
			    				puts "Only one channel at a time\n"+$formatoNEWCHN
			    			else
			    				@canales[canalMSG.upcase] = [[],[]]
			    				puts "Successfully created channel -> #{canalMSG}\n"
			    			end
				    	end
		      		when "REMOVE CH"
		      			if r[:cnls].to_s.empty?
			      			puts $formatoREMOVECHN
				    	else
			    			canalesMSG = r[:cnls].to_s.sub!(/\(/,'').sub!(/\)/,'')
			    			asCanales = canalesMSG.split(',')
			    			asCanales.each do |canal|
			    				canal = canal.strip.upcase
			    				if @canales.has_key?(canal)
			    					puts "Successfully removed channel -> #{canal}\n"
			    					@canales.delete(canal)
			    				else
			    					puts "Channel -> #{canal} does not exist"
			    				end	
			    			end	
				    	end	
				end#case
			else
				puts "Command not found"
			end
	      end
	    rescue Exception => e
	      puts "An exception has occurred: #{e}" 
	    end
	end	
	


	def identificacion(socket, client_addrinfo)
    	typeOfEntity = socket.readline.chomp
    	case typeOfEntity
	    	when "AdCliente"
	    		nombreUsuario = socket.readline.chomp.downcase
	    		@clientes[nombreUsuario] = socket
	    		puts "An user has entered -> #{nombreUsuario}\n"
	    		cargarInfoXML("clientes",nombreUsuario)
	    	when "AdFuente"	
	    		@fuentes.push(socket)	
    	end
    		
	end

	def cargarInfoXML(opcion,data=0)
		
		case opcion
	   		when "canales"
		   		@doc.xpath('/data//canales/canal/text()').each do |canal|	
					@canales[canal.to_s] = [[],[]]			# Array con los dos arrays [[mensajes],[clientes]]
			  	end#do
			when "mensajes"
				#Asignamos los mensajes a los canales
				@canales.each do |k,v|
				  @doc.xpath('/data//mensajesCanales/mensajes[@canal="'+k+'"]/mensaje/text()').each do |mensaje|	
						v[0].push(mensaje.to_s)
				  end#do
				end#do
			when "clientes"
				#Cargamos los canales a los que está suscrito el usuario
				@doc.xpath('/data//clientes/cliente[@nombre="'+data+'"]/canal/text()').each do |canal|	
					#@usuarios[data].push(canal.to_s)
					if @canales.has_key?(canal.to_s) 
						@canales[canal.to_s][1].push(data)
					end
				end#do
		end
	end

end

#Corriendo...
if ARGV.size < 1
  puts "Usage: ruby #{__FILE__} [puerto]"
else
  servidor = AdServidor.new(ARGV[0].to_i)
  servidor.run
end

