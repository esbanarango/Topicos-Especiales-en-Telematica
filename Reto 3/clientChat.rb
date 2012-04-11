=begin
    Archivo: clientChat.rb
    Topicos Especiales en Telematica, Febrero 2012
        Implementación de un servicio de presencia

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
require 'drb'
if Kernel.is_windows? == true
  require 'win32console'
end
load "Modules/designModules.rb"
load "user.rb"

class ClientChat < User

	include DRbUndumped
	include Color

	attr_accessor :host, :puerto, :chat

	def initialize(host,puerto)
		@host = host
		@puerto = puerto
	end

	def run
	    @socket = TCPSocket.new(host, puerto)
	    begin
	    	STDOUT.sync = true
	    	print gris("Enter an username: ")
	    	nombreUsuario = STDIN.gets.chomp
	    	@socket.puts nombreUsuario

	    	DRb.start_service nil, self    
	    	@socket.puts DRb.uri	

	      	puts rojo("Conected...")

	    	hiloLeer = Thread.new { leer }
		    hiloEscribir = Thread.new { escribir}
		    hiloLeer.join
		    hiloEscribir.join
	    ensure
	      @socket.close
	    end
	end

	private

	def leer
		begin
	      while not @socket.eof?
		        line = @socket.gets.chomp
		        if line=~ /(NEW CONECTION) (.+)/i
		        	chat = DRbObject.new nil, $2
				else
					puts line	
		        end	
		   end
	    rescue Exception => e     				#Catch de RUBY
	      puts "Ha ocurrido un error: #{e}"
	    end

	end

	def escribir
		begin
	      while not STDIN.eof?
	        line = STDIN.gets.chomp
	      	if line == "-HELP" || line == "-help"
	      		helpCliente
	      	elsif line == "QUIT" || line == "quit"
	        	exit
	        elsif chat != nil
	        	mandar(line)
	        else
	        	@socket.puts line
	        end	
	      end
	    rescue SystemExit, Interrupt
		    puts("Good Bye! :).")
			Thread.list.each { |t| t.kill }
	    rescue Exception => e
	      puts "Ha ocurrido un error: #{e}"      
	    end
	end

	def mandar(messages)
      	chat.recibir(@userName,messages)
  	end

	def recibir(from,messages)
	    puts("Parce llego un mensaje de: #{from}")
	    puts("\t #{messages}")
	end
end

if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
else
  client = ClientChat.new(ARGV[0], ARGV[1].to_i)
  client.run
end