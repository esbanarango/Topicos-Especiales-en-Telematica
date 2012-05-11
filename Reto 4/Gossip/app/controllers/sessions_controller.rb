class SessionsController < ApplicationController

	def new
  	end

  	def create
  		user = User.find_by_username(params[:session][:username])
    	if user && user.authenticate(params[:session][:password])
      		# Sign the user in and redirect to the user's show page.
    	else
      		flash.now[:error] = 'Invalid email/password combination'
      		render 'new'
    	end
  	end

  	def destroy
  	end
end
