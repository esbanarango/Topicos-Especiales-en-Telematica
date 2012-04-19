=begin
    Archivo: ServerChat.rb
    Topicos Especiales en Telematica, Abril 2012
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
#require 'nokogiri'
require 'readline'
if Kernel.is_windows? == true
  require 'win32console'
end

load "Modules/mainModules.rb"
load "Modules/designModules.rb"
load "User.rb"

class ServerChat

    include Color
    include Help
    include Main

    attr_accessor :puerto, :users, :time

    def initialize(puerto=1212)
        @puerto = puerto
        @users = {}
        @time = Time.new                            
    end

    def run
        puts rojo("Server running...")
        puts "Here you will be able to see all the application activity."
        # hiloAdministrador = Thread.new {mainADMIN} #Main principal del administrador

        Socket.tcp_server_loop(@puerto) {|socket, client_addrinfo|
          Thread.new {
            begin
                register(socket, client_addrinfo);
                mainADMIN(socket)
            ensure
              socket.close 
            end
          }
        }
    end

    private 
    
    def register(socket, client_addrinfo)
        existe = false
        username = socket.readline.chomp
        uri = socket.readline.chomp
        @users.keys.each do |user|
          if(user.userName == username)
            existe = true
            if(user.state=='Offline')
              user.state = 'Online'
              user.uri = uri
              @users[user] = socket
              puts "User "+rojo("->")+" #{username} has logged back in."
              socket.puts purpura("Welcome back!")
              messagesOffline(username)            #Voy a buscar si tiene algún mensaje cuando estaba offline
            elsif(user.state=='Busy' || user.state='Online')
              socket.puts("This users is already conected.")
              newUserName = socket.gets.chomp
              while(username == newUserName)     
                socket.puts("This users is already conected. Try a different username.")
                newUserName = socket.gets.chomp
              end
              existe = false
              username = newUserName
            end
          end
        end 
        if not existe
          user = User.new(uri,username)
          @users[user] = socket
          puts "A new user has entered"+ rojo(" -> ") +"#{username}\n"
          socket.puts purpura("Welcome")
        end               
    end

    #Función encargada de verificar si el usuario tiene mensaje offline
    def messagesOffline(userName)
      @users.keys.each do |user|
          if(user.userName == userName)
              if not user.offlineMessages.empty?
                @users[user].puts ("\n")
                @users[user].puts ("You received "+rojo("#{user.offlineMessages.length}")+" message(s) while you were busy/offline.")
                @users[user].puts rojo("--------------------------------")
                @users[user].puts amarillo("Messages: ")
                user.offlineMessages.each do |userMessages, message|
                  @users[user].puts verde("#{userMessages}")+":"
                  @users[user].puts "#{message}"
                end
                #Limpio los mensajes
                user.offlineMessages.clear 
              end
              break 
          end
      end
    end

    #Función encargada de los mensajes offline y busy
    def leaveMessages(socket,myUserName,userName)
        
        socket.puts "Would you like to leave a messages?.(Y/N) "
        #Aqui situación de carrera ya qeu es el mismo socket
        resp=socket.readline.chomp
        if resp=~RegResps
            socket.puts("Messages to "+verde("#{userName}")+": ")
            offlineMessage =@time.strftime("%Y-%m-%d %H:%M:%S")
            mgs = socket.readline.chomp
            offlineMessage += " "+mgs
            @users.keys.each do |user|
                if(user.userName == userName)
                    if(user.offlineMessages[myUserName] == nil)
                        user.offlineMessages[myUserName] = offlineMessage #Dejo un mensaje a mi nombre en el buzon de el
                    else
                        user.offlineMessages[myUserName] += "\n"+offlineMessage #Dejo un mensaje a mi nombre en el buzon de
                    end
                    break 
                end
            end
            socket.puts "Your message has been left in "+verde("#{userName}")+" inbox."
        end
    end 

end

#Corriendo...
if ARGV.size < 1
  puts "Usage: ruby #{__FILE__} [port]"
else
  server = ServerChat.new(ARGV[0].to_i)
  server.run
end

