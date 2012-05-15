=begin
    Archivo: serverCalls.rb
    Topicos Especiales en Telematica, Mayo 2012
        Cliente Grueso, Gossip Chat

            Esteban Arango Medina
            Sebastian Duque Jaramillo
            Daniel Julian Duque Tirado
=end


module ServerCalls

    # GET /users/exists/:username.json
	def userExist(username)
        request = Net::HTTP::Get.new("/users/exists/#{username}.json")
        response = @http.request(request)
        #puts "Si sera:"+ JSON.parse(response.body).inspect
        JSON.parse(response.body)

	end

    def getData(path,data)
        request = Net::HTTP::Get.new(path+".json")
        if !data.empty?
            request.set_form_data(data)
        end
        response = @http.request(request)
        JSON.parse(response.body)
    end

    def postData(path,data,json)
        request = Net::HTTP::Post.new(path+((json) ? ".json" : ""))
        request.set_form_data(data)
        response = @http.request(request)
        #puts "Si sera el post:"+JSON.parse(response.body).inspect
        JSON.parse(response.body)
    end

end
