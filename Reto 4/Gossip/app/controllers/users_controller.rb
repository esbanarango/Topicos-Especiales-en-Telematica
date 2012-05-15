class UsersController < ApplicationController

  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:api_exists, :api_info] 

  respond_to :json, :html

  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if current_user
      redirect_to root_url
    else
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    respond_to do |format|
      if @user.save

        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: "Welcome to Gossip!" }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /users/1
  # PUT /users/1.json
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  ##Desktop Methods
  # GET /API/users/exists/:username.json
  def api_exists
    response = "no"
    if User.find_by_username(params[:username])
      response = "yes"
    end
    respond_with({:response => response}, :location => users_url)
  end
  # GET' /API/users/:id 
  def api_info
    response = "no"
    user = User.find(params[:id])
    if user
      response = user
    end
    respond_with({:response => response}, :location => users_url)
  end

end
