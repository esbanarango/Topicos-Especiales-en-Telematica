class SessionsController < ApplicationController

	def new
  	end

  	def create
      
  		user = User.find_by_username(params[:session][:username])
    	if user && user.authenticate(params[:session][:password])
      		session[:user_id] = user.id
          redirect_to user
    	else
      		flash.now[:error] = 'Invalid email/password combination'
      		render 'new'
    	end
  	end

  	def destroy
      session[:user_id] = nil
      session[:channel_id] = nil
      redirect_to root_url, :notice => t(:signed_out)
  	end
end
