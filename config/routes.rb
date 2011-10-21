PowerStorm::Application.routes.draw do


  get "admin" => 'admin#index'
  
  resources :buildings
  resources :users
  resources :weathers
  resources :electricity_readings
  resources :meters
  
  root :to => 'Buildings#index'
  
  match 'abr/:abbreviation' => 'Buildings#show'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
end
