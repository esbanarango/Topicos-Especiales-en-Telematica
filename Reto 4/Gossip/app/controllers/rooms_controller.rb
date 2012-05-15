 class RoomsController < ApplicationController
  before_filter :current_user?, :except => [:api_rooms]

  load_and_authorize_resource

  skip_load_and_authorize_resource :only => [:user_out, :api_rooms]

  #respond_to :json, :html, :js

  # GET /rooms
  # GET /rooms.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @user = current_user
    #@room = Room.find(params[:id])
    #New user enter to the room
    RoomsUsers.create!({:user_id => @user.id, :room_id => @room.id})

    @usersIn= @room.users.reverse!

    @messages = @room.messages.all
    @new_message = Message.new

    #PrivatePub.publish_to("/rooms/#{@room.id}", "console.log('entro otra nea')")
    render :layout => "chat_layout"
  end

  # GET /rooms/new
  # GET /rooms/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render json: @room, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end

  def user_out
    @user = current_user
    @room = Room.find(params[:room_id])
    @room.users.destroy(@user)

    #If there are no more users, all the messages are deleted
    if @room.users.size == 0
      @room.messages.delete_all
    end
    PrivatePub.publish_to("/rooms/#{@room.id}", "")
  end


  # GET /API/rooms.json
  def api_rooms
    @rooms = Room.all
    respond_to do |format|
      format.json { render json: @rooms }
    end
  end


end
