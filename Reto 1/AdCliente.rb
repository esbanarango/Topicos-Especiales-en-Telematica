=begin
	Archivo: AdCliente.rb
	Topicos Especiales en Telematica, Febrero 2012
		Implementacion de un servicio de Anuncios Distribuido

			Esteban Arango Medina
			Daniel Julian Duque Tirado
			Sebastian Duque Jaramillo
=end
require "socket"
require 'nokogiri'
require 'readline'

class AdCliente
	attr_accessor :host, :puerto

	def initialize(host,puerto)
		@host = host
		@puerto = puerto
	end

	def run
		puts("Conectando...")
	    @socket = TCPSocket.new(host, puerto)
	    begin
	    	@socket.puts "AdCliente"					#Me identifico ante el servidor como un AdFuente
	    	STDOUT.sync = true
	    	print "Enter an username: "
	    	nombreUsuario = STDIN.gets.chomp
	      	@socket.puts nombreUsuario

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
		        puts line
		   end
	    rescue Exception => e     				#Catch de RUBY
	      puts "Ha ocurrido un error: #{e}"
	    end

	end

	def escribir
		begin
	      while not STDIN.eof?
	        line = STDIN.gets.chomp
	      	@socket.puts line
	      end
	    rescue Exception => e
	      puts "Ha ocurrido un error: #{e}"      
	    end
	end


end

if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} [host] [port]"
else
  puts "Welcome!"
  
  client = AdCliente.new(ARGV[0], ARGV[1].to_i)
  client.run
end