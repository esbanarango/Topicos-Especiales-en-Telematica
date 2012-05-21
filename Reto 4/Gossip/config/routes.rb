Gossip::Application.routes.draw do

  root to: 'static_pages#home'

  match '/', to: 'static_pages#home'

  match '/error', to: 'static_pages#error'

  resources :rooms do
    resources :messages
  end

  resources :users

  resources :sessions, only: [:new, :create, :destroy]

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  
  #Private messages
  match '/rooms/:room_id/messages_private(.:format)',  to: 'messages#create_private', :via => 'POST', :as => "private_message"
  match '/rooms/:room_id/get_private_messages(.:format)',  to: 'messages#get_private_messages', :via => 'POST', :as => "get_private_message"

  match '/rooms/:room_id/user_out/:id',  to: 'rooms#user_out', :via => 'GET'
  match '/rooms/:room_id/user_report/:id',  to: 'rooms#user_report', :via => 'GET'

  #------------------------Gossip Thick Routes
  match '/API/users/exists/:username',  to: 'users#api_exists', :via => 'GET'
  match '/API/users/:id',  to: 'users#api_info', :via => 'GET'

  match '/API/rooms',  to: 'rooms#api_rooms', :via => 'GET'

  #User enter a room from the desktop client
  match '/API/rooms/join',  to: 'rooms#api_join_room', :via => 'GET'
  #User leave a room from the desktop client
  match '/API/rooms/leave',  to: 'rooms#api_leave_room', :via => 'GET'

  match '/API/messages',  to: 'messages#api_create', :via => 'POST'


end
