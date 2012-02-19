=begin
	Archivo: AdServidor.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end

def Kernel.is_windows?
  processor, platform, *rest = RUBY_PLATFORM.split("-")
  platform == 'mingw32'
end

require "socket"
require 'nokogiri'
require 'readline'
if Kernel.is_windows? == true
  require 'win32console'
end
load "Modules/mainModules.rb"
load "Modules/designModules.rb"
load "Persistence/XmlHandler.rb"

class AdServidor

	include Main
	include Color
	include Help
	include XmlHandler

	attr_accessor :puerto, :canales, :fuentes, :clientes, :doc

	def initialize(puerto=1212)
		@puerto = puerto
		@fuentes = []
		@canales = {}							  #Creación del Hash de canales
		@clientes = {}
		@doc = Nokogiri::XML File.open 'Persistence/data.xml'	
		cargarInfoXML('canales')				  #Cargamos los canales del XML
		cargarInfoXML('mensajes')				  #Cargamos los mensajes del XML
		cargarInfoXML('clientes')				  #Cargamos los clientes del XML
	end

	def run
		puts rojo("Server running...")
		
		hiloAdministrador = Thread.new {mainADMIN} #Main principal del administrador

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
	
	def identificacion(socket, client_addrinfo)
    	typeOfEntity = socket.readline.chomp
    	case typeOfEntity
	    	when "AdCliente"
	    		nombreUsuario = socket.readline.chomp.downcase
	    		@clientes[nombreUsuario] = socket
	    		puts "A new client has entered"+ rojo(" -> ") +"#{nombreUsuario}\n"
	    		#cargarInfoXML("clientes",nombreUsuario)
	    	when "AdFuente"	
	    		@fuentes.push(socket)
	    		puts "A new 'source' has entered"+ rojo(" -> ") +"ip: #{client_addrinfo.ip_address} - port: #{client_addrinfo.ip_port} \n"	
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

