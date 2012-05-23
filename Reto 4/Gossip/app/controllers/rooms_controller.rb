 require 'API_module'

 class RoomsController < ApplicationController
  before_filter :current_user?, :except => [:api_rooms, :api_join_room, :api_leave_room]

  load_and_authorize_resource

  skip_load_and_authorize_resource :only => [:user_out, :subscribe_private, :api_rooms, :api_join_room, :api_leave_room]

  include APIModule

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
    isAreadyInside = RoomsUsers.find_by_user_id_and_room_id(@user.id,@room.id)
    if(isAreadyInside == nil)
      #New user enter to the room
      RoomsUsers.create!({:user_id => @user.id, :room_id => @room.id})

      @usersIn= @room.users.reverse!
      @privateMessages={}

      @usersIn.each { |u|  
        if u.id != current_user.id
          @privateMessages[u.id] = Message.where(" 'messages'.'room_id' = ? and (('messages'.'to'  = ? and 'messages'.'user_id' = ?) or ('messages'.'to' = ? and 'messages'.'user_id' = ?))",@room.id,current_user.id,u.id,u.id,current_user.id)
        end
      }

      @messages = @room.messages.where('"messages"."to" is NULL')

      @new_message = Message.new

      #PrivatePub.publish_to("/rooms/#{@room.id}", "console.log('entro otra nea')")
      render :layout => "chat_layout"
    else
      redirect_to(root_url, :notice => "It seems you're already on that room")
    end
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
    #PrivatePub.publish_to("/rooms/#{@room.id}", "")
  end

#------------API METHODS

  # GET /API/rooms.json
  def api_rooms
    @rooms = Room.all
    respond_to do |format|
      format.json { render json: @rooms }
    end
  end

  # GET    /API/rooms/:id/join(.:format)                  
  def api_join_room

    #New user enter to the room
    RoomsUsers.create!({:user_id => params[:user_id], :room_id => params[:room_id]})

    #Generate de js to publish
    jsScript = newUserEnter(params[:user_id])
    PrivatePub.publish_to("/rooms/#{params[:room_id]}", jsScript)

    respond_to do |format|
        format.json { render json: {response: "Enter success"}, status: :unprocessable_entity }
      end

  end 

  # GET    /API/rooms/:id/leave(.:format)
  def api_leave_room


    @user = User.find(params[:user_id])
    @room = Room.find(params[:room_id])
    @room.users.destroy(@user)

    #If there are no more users, all the messages are deleted
    if @room.users.size == 0
      @room.messages.delete_all
    end

    #Generate de js to publish
    jsScript = userLeaves(@user)
    PrivatePub.publish_to("/rooms/#{params[:room_id]}", jsScript)
    PrivatePub.publish_to("/rooms/#{params[:room_id]}", "$('#num-users').text($('#liUsers a').size())")

    respond_to do |format|
      format.json { render json: {response: "Bye"}, status: :unprocessable_entity }
    end

     
  end


end
