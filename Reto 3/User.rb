class User
	attr_accessor :uri, :userName, :state, :offlineMessages

    def initialize(uri,userName)
    	@uri=uri
    	@userName=userName
    	@state="Online"
    end

end