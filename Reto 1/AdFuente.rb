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

class AdFuente

	$formatoNEWMSG = "Format: NEWMSG (channel1,...) message\n Or type -HELP"
	$ayuda = ""

	attr_accessor :host, :puerto

	def initialize(host,puerto)
		@host = host
		@puerto = puerto
	end

	def run
		puts("Conected...")
	    @socket = TCPSocket.new(host, puerto)
	    begin
	    	@socket.puts "AdFuente"					#Me identifico ante el servidor como un AdFuente
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
		        mensaje = @socket.gets.chomp
		        if mensaje=~ /(ERR) (1|2|3)/
		        	case $2
			    		when "1"
			    			puts "Command not found"
					    	puts $formatoNEWMSG
				    	when "2"
					    	puts "Error: You have to set at least one channel"
					    	puts $formatoNEWMSG
					    when "3"
					    	puts "Error: You have to enter a message"
					    	puts $formatoNEWMSG
				    end
				else
					puts mensaje	
		        end		        
		    end#while
	    rescue Exception => e     				
	      puts "An error has occurred: #{e}"
	    end

	end

	def escribir
		begin
	      while not STDIN.eof?
	        line = STDIN.gets.chomp
	        if line == "-HELP"
	        	puts "Esta es la ayuda"
	        else
	        	@socket.puts line
	        end	      	
	      end
	    rescue Exception => e
	      puts "An error has occurred: #{e}"      
	    end
	end


end

if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
else
  puts "Welcome!"
  
  fuente = AdFuente.new(ARGV[0], ARGV[1].to_i)
  fuente.run
end