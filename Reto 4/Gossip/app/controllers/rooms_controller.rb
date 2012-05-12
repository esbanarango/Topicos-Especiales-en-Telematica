 class RoomsController < ApplicationController
  before_filter :current_user?

  #respond_to :json, :html, :js

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @user = current_user
    @room = Room.find(params[:id])
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
    @room = Room.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(params[:room])

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
    @room = Room.find(params[:id])

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
    @room = Room.find(params[:id])
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
    PrivatePub.publish_to("/rooms/#{@room.id}", "")
    #respond_with({:response => "listo"}, :location => rooms_url)
  end


end
