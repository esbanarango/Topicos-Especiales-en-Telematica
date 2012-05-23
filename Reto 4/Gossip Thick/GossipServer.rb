=begin
    Archivo: GossipServer.rb
    Topicos Especiales en Telematica, Mayo 2012
        Cliente Grueso, Gossip Chat

            Esteban Arango Medina
            Sebastian Duque Jaramillo
            Daniel Julian Duque Tirado
=end

def Kernel.is_windows?
  processor, platform, *rest = RUBY_PLATFORM.split("-")
  platform == 'mingw32'
end


require 'net/http'
require 'json'
require 'nokogiri'
require 'readline'
require 'yaml'
require 'digest/md5'
require "highline/import"

if Kernel.is_windows? == true
  require 'win32console'
end

load "Modules/designModules.rb"
load "Modules/mainModules.rb"
load "Modules/serverCalls.rb"


class GossipServer

	include Color
	include Help
	include ServerCalls
	include Main

	attr_accessor :serverUri, :username, :user_id, :http, 
				  :current_room_id, :channels, :lastMessage, 
				  :connected, :newInTheChannel, :users

	def initialize
		config = YAML.load_file(File.expand_path("./config/config.yml"))
		@serverUri = URI(config["server"]) 
		@http = Net::HTTP.new(@serverUri.host, @serverUri.port)

		@channels = getData("/API/rooms","",true)
		@users = {}
		
		@connected = false
		@lastMessage = 0
        @current_room_id = 0
		@newInTheChannel = true #To show my old messages but not the new ones
    end

    def run
        puts rojo("Gossip running...")
        puts amarillo("\t\tGossip")
        puts gris("\tNote:")+" Consider to use the web app in order to be able to use the full features."
    	puts "\tWelcome to Gossip chat, please insert your username."
    	puts "\tIn case you don't have a username insert one and we'll check the availability in order to"
    	puts "\tproceed with the Signup process!. :)"
        #Sigin or Singup
        identify()
        receiveMessageThread = Thread.new { receiveMessage }
        mainThread = Thread.new { main }
        receiveMessageThread.join
        
    end

    private

    def identify
		print gris("\tUsername: ")
		@username = STDIN.gets.chomp
		if serverCall("existUser", @username)
			signin
		else
			system "clear"
			puts "\tUsername "+rojo("#{@username}")+" does not exists."
			print "\tDo you want to try again?(y/n): "
			tryAgain = STDIN.gets.chomp
			exists = false
			while(tryAgain=~RegResps) do
				print gris("\tUsername: ")
				@username = STDIN.gets.chomp
				if serverCall("existUser", @username)
					exists=true
					break
				end
				system "clear"
				puts "\tUsername "+rojo("#{@username}")+" does not exists."
				print "\tDo you want to try again?(y/n): "
				tryAgain = STDIN.gets.chomp
			end
			exists ? signin : signup
		end
    end

    def signin
    	print gris("\tPassword:")
    	password = ask(" ") {|q| q.echo = "x"}
    	data = {	"session[username]" 				=> @username,
    				"session[password]" 				=> password,
                    "session[device]"                   => "desktop"
    			}
    	jsonResponse = 	serverCall("signin", data)	
    	#If there is a 'response' key in the hash, then there was an error.
    	if jsonResponse['response']
    		system "clear"
    		puts rojo("\t#{jsonResponse['response']}")
    		identify
    	else
    		#Otherwise, get the user_id
    		@user_id = jsonResponse['id']
    	end
    	
    end

    def signup
    	system "clear"
    	puts amarillo("\t\tGossip Signup")
    	puts "\tWelcome to Gossip Chat and thank you for use our service."
    	puts "\tYou are creating a new account."
    	print gris("\tUsername: ")
    	@username = STDIN.gets.chomp
    	print gris("\tPassword:")
    	password = ask(" ") {|q| q.echo = "x"}
    	#Error typing
    	if(password.size < 6)
    		begin
    			puts rojo("\tPassword is too short (minimum is 6 characters)")
    			print gris("\tPassword:")
    			password = ask(" ") {|q| q.echo = "x"}
    		end while(password.size < 6)
    	end
    	print gris("\tPassword confirmation:")
    	passwordConfirmation = ask(" ") {|q| q.echo = "x"}
		#Error typing
    	if(password != passwordConfirmation)
    		begin
    			puts rojo("\tPassword does not match confirmation")
    			print gris("\tPassword confirmation:")
    			passwordConfirmation = ask(" ") {|q| q.echo = "x"}
    		end while(password != passwordConfirmation)
    	end
    	data = {	"user[username]" 				=> @username,
    				"user[password]" 				=> password,
    				"user[password_confirmation]"	=> passwordConfirmation,
                    "user[device]"   => "desktop"
    			}
    	jsonResponse = serverCall("signup", data)
        @user_id = jsonResponse['id']
    end

    def serverCall(type, data)
    	case type
    		when "existUser"
    			(userExist(data)['response'] == "yes") ? true : false 
    		when "signin"
    			postData("/sessions",data,true)
    		when "signup"	
    			# POST /users.json
    			postData("/users",data,true)		    					    	
		end

    	
    end


end

desktop = GossipServer.new

desktop.run


