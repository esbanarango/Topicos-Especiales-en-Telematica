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
        
    end

    def sendMessage
        
    end

    def receiveMessage
        
    end

end