=begin
    Archivo: designModules.rb
    Topicos Especiales en Telematica, Abril 2012
        Implementación de un servicio de presencia

            Esteban Arango Medina
            Sebastian Duque Jaramillo
            Daniel Julian Duque Tirado
=end
module Color
	def gris(texto); coloriar(texto, "\e[1m\e[37m"); end
    def rojo(texto); coloriar(texto, "\e[1m\e[31m"); end
    def verde(texto); coloriar(texto, "\e[1m\e[32m"); end
    def verde_oscuro(texto); coloriar(texto, "\e[1m\e[32m"); end
    def amarillo(texto); coloriar(texto, "\e[1m\e[33m"); end
    def azul(texto); coloriar(texto, "\e[1m\e[34m"); end
    def azul_oscuro(texto); coloriar(texto, "\e[34m"); end
    def purpura(texto); coloriar(texto, "\e[1m\e[35m"); end
    def coloriar(texto, codigo)  "#{codigo}#{texto}\e[0m" end
end

module Help
	def helpAdmin
		puts "\t\t\t"+amarillo("* "*12)
    	puts "\t\t\t"+amarillo("* ")+verde("Available commands: ")+amarillo("*")
    	puts "\t\t\t"+amarillo("* "*12)
    	puts "\t- "+amarillo("LIST CH")+gris("\t\t\t => Lists all channels that are currently active in the server")
    	puts "\t- "+amarillo("LIST CLIENTS")+gris("\t\t\t => Lists all clients that are currently conected in the server")
    	puts "\t- "+amarillo("NEW CH (ChannelName)")+gris("\t\t => Creates a new channel")
    	puts "\t- "+amarillo("REMOVE CH (Channel1,...)")+gris("\t => Removes multiple channels")
    	puts "\t- "+amarillo("-HELP")+gris("\t\t\t\t => Shows all the available commands")
    	puts "\t- "+amarillo("QUIT")+gris("\t\t\t\t => Quits the program")
	end

	def helpUser
		puts "\t\t\t"+amarillo("* "*12)
    	puts "\t\t\t"+amarillo("* ")+verde("Available commands: ")+amarillo("*")
    	puts "\t\t\t"+amarillo("* "*12)
    	puts "\t- "+amarillo("LIST USERS")+gris("\t\t\t => Lists the status of all the users.")
        puts "\t- "+amarillo("CHAT (user-name)")+gris("\t\t => Starts a conversation with 'user-name'.")
    	puts "\t- "+amarillo("-HELP")+gris("\t\t\t\t => Shows all the available commands.")
    	puts "\t- "+amarillo("QUIT")+gris("\t\t\t\t => Quits the program.")
	end
end