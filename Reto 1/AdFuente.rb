#ADFUENTE
require "socket"
require 'nokogiri'
require 'readline'

class AdFuente
	attr_accessor :host, :puerto

	def initialize(host,puerto)
		@host = host
		@puerto = puerto
	end

	def run
		puts("Conectando...")
	    @socket = TCPSocket.new(host, puerto)
	    begin
	    	@socket.puts "AdFuente"
	    	# Connected, let's start the threads
		    thread1 = Thread.new { leer }
		    thread2 = Thread.new { escribir}
		      
		    thread1.join
		    thread2.join
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
  puts "Uso: ruby #{__FILE__} [host] [port]"
else
  puts "Bienvenido!"
  
  fuente = AdFuente.new(ARGV[0], ARGV[1].to_i)
  fuente.run
end