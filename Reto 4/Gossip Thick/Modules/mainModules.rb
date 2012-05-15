=begin
    Archivo: mainModules.rb
    Topicos Especiales en Telematica, Mayo 2012
        Cliente Grueso, Gossip Chat

            Esteban Arango Medina
            Sebastian Duque Jaramillo
            Daniel Julian Duque Tirado
=end

#Expresiones regulares para los mensajes proveninetes del los usuarios
RegUserActions = %r{(?<cdg>(?i)LIST CHANNELS|JOIN CHANNEL|QUIT|RESP CONVER) *(?<user>\(.{1,}\))?}
RegResps = %r{(Y|y|S|s|Yes|YES|yes|YeS|yEs|si|Si|sI)}


module Main

    def main
        puts "\tWelcome to Gossip Chat and thank you for use our service.!"
        puts "\tType "+amarillo('-help')+" to see the avalible commands")
        begin
          while not STDIN.eof?
            line = STDIN.gets.chomp
            if line == "-HELP" || line == "-help"
                helpUser
            elsif line == "QUIT" || line == "quit"
                exit
            end 
          end
        rescue SystemExit, Interrupt
            puts("Good Bye! :).")
            Thread.list.each { |t| t.kill }
        rescue Exception => e
          puts "Ha ocurrido un error: #{e}"      
        end
    end

    def sendMessage
        
    end

    def receiveMessage
        
    end

end