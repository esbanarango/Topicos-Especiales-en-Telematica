 require 'API_module'

class MessagesController < ApplicationController

  include APIModule

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where("'messages'.'room_id' = ? and 'messages'.'to' is NULL", params[:room_id])
    totalMessages = (@messages.size>10) ? 9 : @messages.size
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json:  @messages.reverse[0..totalMessages].reverse }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new params[:message]
    @message.user_id = current_user.id 
    @message.save
  end

  # POST /messages_private.json
  def create_private
    @message = Message.new params[:message]

    to_id   = params[:message][:to]
    room_id = params[:room_id]

    @message.user_id = current_user.id 
    @message.room_id = params[:room_id]
    @message.save

  end

  # PUT /messages/1
  # PUT /messages/1.json 
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  def get_private_messages
    @user_id = params[:user_id]
    @room = Room.find(params[:room_id])
    @privateMessages = Message.where("'messages'.'room_id' = ? and (('messages'.'to'  = ? and 'messages'.'user_id' = ?) or ('messages'.'to' = ? and 'messages'.'user_id' = ?))",@room.id,current_user.id,@user_id,@user_id,current_user.id)
    @new_message = Message.new
    render :layout => false
  end



  #API METHOD
  #  match '/API/messages.json',  to: 'messages#api_create', :via => 'POST'
  def api_create
    @message = Message.new
    @message.user_id = params[:message][:user_id]
    @message.room_id = params[:message][:room_id]
    @message.content = params[:message][:content]
    @message.save

    #Generate de js to publish
    jsScript = createMessage(@message)
    PrivatePub.publish_to("/rooms/#{@message.room_id}", jsScript)

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.json { render json: @message}
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


end
