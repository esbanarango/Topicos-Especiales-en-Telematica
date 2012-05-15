class SessionsController < ApplicationController

  def new
    if current_user
      redirect_to root_url
    end
  end

  def create
    user = User.find_by_username(params[:session][:username])
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        format.html { redirect_to user }
        format.json { render json: user, status: :created, location: user }
      else
        flash.now[:error] = 'Invalid username/password combination'
        format.html { render action: "new" }
        format.json { render json: {response: "Invalid username/password combination"}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:channel_id] = nil
    redirect_to root_url, notice: "Bye, come back soon!; btw, You're Awesome!"
  end

end
