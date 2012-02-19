=begin
	Archivo: AdCliente.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Sebastian Duque Jaramillo
			Daniel Julian Duque Tirado
=end
require "socket"
require 'nokogiri'
require 'readline'
load "designModules.rb"

class AdCliente

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
	    	@socket.puts "AdCliente"					#Me identifico ante el servidor como un AdCliente
	    	STDOUT.sync = true
	    	print gris("Enter an username: ")
	    	nombreUsuario = STDIN.gets.chomp
	      	@socket.puts nombreUsuario

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
		        if line=~ /(ERR) (1|2)/
		        	case $2
			    		when "1"
			    			puts amarillo("Command not found")			    			
				    	when "2"
					    	puts amarillo("Error: You have to set at least one channel")				    	
				    end
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


end

if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
else
  client = AdCliente.new(ARGV[0], ARGV[1].to_i)
  client.run
end