=begin
	Archivo: AdFuente.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end

def Kernel.is_windows?
  processor, plataform, *rest = RUBY_PLATFORM.split("-")
  plataform == 'mingw32'
end

require "socket"
require 'nokogiri'
require 'readline'
if Kernel.is_windows? == true
  require 'win32console'
end
load "Modules/designModules.rb"

class AdFuente

	include Color
	include Help

	attr_accessor :host, :puerto

	def initialize(host,puerto)
		@host = host
		@puerto = puerto
	end

	def run
	    @socket = TCPSocket.new(host, puerto)
	    begin
	    	@socket.puts "AdFuente"					#Me identifico ante el servidor como un AdFuente
		    hiloLeer = Thread.new { leer }
		    hiloEscribir = Thread.new { escribir}
		    puts rojo("Conected...")
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
		        mensaje = @socket.gets.chomp
		        if mensaje=~ /(ERR) (1|2|3)/
		        	case $2
			    		when "1"
			    			puts amarillo("Command not found") 
				    	when "2"
					    	puts amarillo("Error: You have to set at least one channel")
					    when "3"
					    	puts amarillo("Error: You have to enter a message")
				    end
				else
					puts mensaje	
		        end		        
		    end#while
	    rescue Exception => e     				
	      puts "An exception has occurred: #{e}"
	    end

	end

	def escribir
		begin
	      while not STDIN.eof?
	        line = STDIN.gets.chomp
	        if line == "-HELP" || line == "-help"
	        	helpFuente
	        elsif line == "QUIT" || line == "quit"
	        	exit
	        else
	        	@socket.puts line
	        end	      	
	      end
	    rescue SystemExit, Interrupt
		    puts("Good Bye! :).")
			Thread.list.each { |t| t.kill }
	    rescue Exception => e
	      puts "An exception has occurred: #{e}"      
	    end
	end


end

if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
else
  fuente = AdFuente.new(ARGV[0], ARGV[1].to_i)
  fuente.run
end