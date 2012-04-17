=begin
    Archivo: serverChat.rb
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
require 'nokogiri'
require 'readline'
if Kernel.is_windows? == true
  require 'win32console'
end

load "Modules/mainModules.rb"
load "Modules/designModules.rb"
load "user.rb"

class ServerChat

    include Color
    include Help
    include Main

    attr_accessor :puerto, :users

    def initialize(puerto=1212)
        @puerto = puerto
        @users = {}                            
    end

    def run
        puts rojo("Server running...")
        
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
              puts "#{username} has logged back in"
              socket.puts("Welcome")
            elsif(user.state=='Busy' || user.state='Online')
              socket.puts("Este usuario ya esta conectado")
              newUserName = socket.gets.chomp
              while(username == newUserName)     
                socket.puts("Este usuario ya esta conectado")
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
          socket.puts("Welcome")
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

