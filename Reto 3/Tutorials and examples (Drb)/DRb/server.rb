require 'drb'

class Chat
  include DRbUndumped
  attr_accessor :elChat, :yo

  def initialize()
        DRb.start_service nil, self
        puts("User1 "+ DRb.uri)
        DRb.thread.join
  end

  def emparejar(name,uri)
      @elChat = DRbObject.new nil, uri
      @yo = name
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