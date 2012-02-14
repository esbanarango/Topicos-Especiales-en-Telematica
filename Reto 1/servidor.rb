#SERVIDOR
require "socket"
require 'nokogiri'
require 'readline'


class Servidor
	attr_accessor :puerto,:canales,:fuentes,:usuarios
	def initialize(puerto=1212)
		@puerto = puerto
		@fuentes = []
		@canales = {}							#Creación del Hash de canales
		@usuarios = {}
			
		cargarInfoXML('canales')				#Cargamos los canales del XML
		cargarInfoXML('mensajes')				#Cargamos los mensajes del XML
	end

	def run
		puts "Servidor corriendo..."
		Socket.tcp_server_loop(@puerto) {|socket, client_addrinfo|
		  Thread.new {
		    begin
		    	identificacion(socket, client_addrinfo)
		    	puts "Ingreso alguien"
			    while not socket.eof?			    
			    	line = socket.readline.chomp
			    	if @fuentes.include?(socket)
				    	#Logic
				    	case line
				    		when "canales"
					    		socket.puts @canales.keys
					    	else
					    		socket.puts @canales[line][0]
					    end
					end
				end
			ensure
		      socket.close 
		    end
		  }
		}
	end

	private
	
	def identificacion(socket, client_addrinfo)
    	typeOfEntity = socket.readline.chomp
    	case typeOfEntity
	    	when "AdCliente"
	    		user = socket.readline.chomp
	    		@usuarios[user] = []
	    		cargarInfoXML("usuarios",user)
	    	when "AdFuente"	
	    		@fuentes.push(socket)	
    	end
    		
	end

	def cargarInfoXML(opcion,data=0)
		doc = Nokogiri::XML File.open 'data.xml'
		case opcion
	   		when "canales"
			  doc.xpath('/data//canales/canal/text()').each do |canal|	
					@canales[canal.to_s] = [[],[]]			# Array con los dos arrays [[Mensajes],[Usuarios]]
			  end
			when "mensajes"
				#Asignamos los mensajes a los canales
				canales.each {|k,v|
				  doc.xpath('/data//mensajesCanales/mensajes[@canal="'+k+'"]/mensaje/text()').each do |mensaje|	
						v[0].push(mensaje.to_s)
				  end
				}
			when "usuarios"
				doc.xpath('/data//usuarios/usuario[@nombre="'+data+'"]/canal/text()').each do |canal|	
					@usuarios[data].push(canal.to_s)
				end
			  
		end
	end

end

if ARGV.size < 1
  puts "Uso: ruby #{__FILE__} [puerto]"
else
  servidor = Servidor.new(ARGV[0].to_i)
  servidor.run
end

