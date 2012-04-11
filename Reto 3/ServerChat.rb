=begin
    Archivo: serverChat.rb
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
if Kernel.is_windows? == true
  require 'win32console'
end

load "Modules/mainModules.rb"
load "Modules/designModules.rb"
load "user.rb"

class ServerChat

    include Color
    attr_accessor :puerto, :onlineUsers, :offlineUsers

    def initialize(puerto=1212)
        @puerto = puerto
        @users = {}                             #Creación del Hash de canales
    end

    def run
        puts rojo("Server running...")
        
        # hiloAdministrador = Thread.new {mainADMIN} #Main principal del administrador

        Socket.tcp_server_loop(@puerto) {|socket, client_addrinfo|
          Thread.new {
            begin
                register(socket, client_addrinfo);
                while not socket.eof?
                    line = socket.readline.chomp
                    r = RegUserActions.match(line)
                    unless r.nil?
                        case r[:cdg]
                            when "LIST USERS"
                                socket.puts gris("Online users:")
                                @users.keys.each do |user|  
                                    socket.puts verde("\t #{user.userName}") if user.state == "Online"
                                end
                                socket.puts gris("Busy users:")
                                @users.keys.each do |user|
                                    socket.puts amarillo("\t #{user.userName}") if user.state == "Busy"
                                end
                                socket.puts gris("Offline users:")
                                @users.keys.each do |user|
                                    socket.puts azul("\t #{user.userName}") if user.state == "Offline"
                                end
                                socket.puts "\n"
                            when "CHAT" 
                                #Verificar que no sea el mismo
                                userName = r[:user].to_s.sub!(/\(/,'').sub!(/\)/,'')
                                puts "tarando de conectar con #{userName}"
                                existe=false
                                userConectTo= @users.invert[socket]
                                uriUserConectTo = userConectTo.uri
                                @users.keys.each do |user|
                                    if(user.userName == userName) 
                                       socket.puts ("NEW CONECTION #{user.uri}")     #Me conecto con el 
                                       @users[user].puts("NEW CONECTION #{uriUserConectTo}") #El se conecta conmigo
                                       existe=true
                                    end
                                end
                                if(!existe)
                                    socket.puts "ERR 1"
                                end                                     
                        end#case
                    else
                        puts "parce pillat eloq ue pusieron: #{line}"
                        socket.puts "ERR 1"
                    end
                end#while
            ensure
              socket.close 
            end
          }
        }
    end

    private 
    
    def register(socket, client_addrinfo)
        username = socket.readline.chomp
        uri = socket.readline.chomp
        user = User.new(uri,username)
        @users[user] = socket
        puts "A new user has entered"+ rojo(" -> ") +"#{username}\n"
    end
end

#Corriendo...
if ARGV.size < 1
  puts "Usage: ruby #{__FILE__} [puerto]"
else
  server = ServerChat.new(ARGV[0].to_i)
  server.run
end

