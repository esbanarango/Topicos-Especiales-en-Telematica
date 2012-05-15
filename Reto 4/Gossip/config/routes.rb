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
  

  match '/rooms/:room_id/user_out/:id',  to: 'rooms#user_out', :via => 'GET'
  match '/rooms/:room_id/user_report/:id',  to: 'rooms#user_report', :via => 'GET'

  #Gossip Thick Routes
  match '/users/exists/:username',  to: 'users#exists', :via => 'GET'
  match '/API/rooms',  to: 'rooms#api_rooms', :via => 'GET'
  match '/API/messages',  to: 'messages#api_create', :via => 'POST'


end
