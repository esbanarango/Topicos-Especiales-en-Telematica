=begin
    Archivo: User.rb
    Topicos Especiales en Telematica, Abril 2012
        Implementación de un servicio de presencia

            Esteban Arango Medina
            Sebastian Duque Jaramillo
            Daniel Julian Duque Tirado
=end
class User
	attr_accessor :uri, :userName, :state, :offlineMessages, :response, :response_text

    def initialize(uri,userName)
    	@uri=uri
    	@userName=userName
    	@state="Online"
    	@offlineMessages={}
        @response=false
    end

end