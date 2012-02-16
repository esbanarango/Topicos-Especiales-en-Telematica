=begin
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Daniel Julian Duque Tirado
			Sebastian Duque Jaramillo
=end
require "socket"
require 'nokogiri'
require 'readline'

#Expresion regular para los mensajes proveninetes del AdFuente
RegAdFuente = %r{(?<cdg>LIST CH|NEWMSG) ?(?<cnls>\(.{1,}\))? ?(?<msg>.*)?}

class Servidor
	attr_accessor :puerto,:canales,:fuentes,:usuarios, :doc

	def initialize(puerto=1212)
		@puerto = puerto
		@fuentes = []
		@canales = {}							#Creación del Hash de canales
		@usuarios = {}
		@doc = Nokogiri::XML File.open 'data.xml'	
		cargarInfoXML('canales')				#Cargamos los canales del XML
		cargarInfoXML('mensajes')				#Cargamos los mensajes del XML
	end

	def run
		puts "Server running..."
		
		hiloAdministrador = Thread.new {mainADMIN}

		Socket.tcp_server_loop(@puerto) {|socket, client_addrinfo|
		  Thread.new {
		    begin
		    	identificacion(socket, client_addrinfo)	    
		    	if @fuentes.include?(socket)
		    		mainAdFuente(socket)		#Main principal de las acciones del AdFuente
		    	else
		    		mainAdCliente(socket)		#Main principal de las acciones del AdCliente
				end
			ensure
		      socket.close 
		    end
		  }
		}
	end

	private

	def mainAdFuente(socket)
		while not socket.eof?
			line = socket.readline.chomp
			r = RegAdFuente.match(line)
			unless r.nil?
				case r[:cdg]
		    		when "LIST CH"					#Listar los canales existentas al AdFuente
			    		socket.puts @canales.keys
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
			    				if @canales.has_key?(canal.upcase) 
			    					@canales[canal][0].push(mensajeMSG)
			    				end
			    			end
			    		end							
			    end
			else
				socket.puts "ERR 1"
			end
		end
	end	

	def mainAdCliente(socket)
		#Ver los mensajes de un canal () socket.puts @canales[line][0]
		while not socket.eof?
		end
	end	

	def mainADMIN()
		begin
	      while not STDIN.eof?
	        line = STDIN.gets.chomp
	      	puts line + "si funciona"
	      end
	    rescue Exception => e
	      puts "Ha ocurrido un error: #{e}"      
	    end
	end	
	
	def identificacion(socket, client_addrinfo)
    	typeOfEntity = socket.readline.chomp
    	case typeOfEntity
	    	when "AdCliente"
	    		nombreUsuario = socket.readline.chomp
	    		@usuarios[nombreUsuario] = []
	    		cargarInfoXML("usuarios",nombreUsuario)
	    	when "AdFuente"	
	    		@fuentes.push(socket)	
    	end
    		
	end

	def cargarInfoXML(opcion,data=0)
		
		case opcion
	   		when "canales"
		   		@doc.xpath('/data//canales/canal/text()').each do |canal|	
					@canales[canal.to_s] = [[],[]]			# Array con los dos arrays [[Mensajes],[Usuarios]]
			  	end#do
			when "mensajes"
				#Asignamos los mensajes a los canales
				@canales.each do |k,v|
				  @doc.xpath('/data//mensajesCanales/mensajes[@canal="'+k+'"]/mensaje/text()').each do |mensaje|	
						v[0].push(mensaje.to_s)
				  end#do
				end#do
			when "usuarios"
				#Cargamos los canales a los que está suscrito el usuario
				@doc.xpath('/data//usuarios/usuario[@nombre="'+data+'"]/canal/text()').each do |canal|	
					@usuarios[data].push(canal.to_s)
				end#do
		end
	end

end

if ARGV.size < 1
  puts "Usage: ruby #{__FILE__} [puerto]"
else
  servidor = Servidor.new(ARGV[0].to_i)
  servidor.run
end

