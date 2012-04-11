require 'drb'

class Chat
  include DRbUndumped
  attr_accessor :elChat, :yo

  def initialize()
		DRb.start_service nil, self
		puts("User1 "+ DRb.uri)
		hiloEscribir = Thread.new { escribir}
		hiloEscribir.join
  end

  def ini(name,uri)
  	    @elChat = DRbObject.new nil, uri
        @yo = name
  end

  def out

  end

  def escribir
		begin
	      while not STDIN.eof?
	        line = STDIN.gets.chomp
	        if elChat == nil
	        	ini("esban",line)
	    	else
	    		mandar(line)
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
      @elChat.recibir(@yo,messages)
  end

  def recibir(from,messages)
      puts("Parce llegó un mensaje de: #{from}")
      puts("\t #{messages}")
  end

end


chat = Chat.new()
