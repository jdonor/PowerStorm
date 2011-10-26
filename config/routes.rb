PowerStorm::Application.routes.draw do


  get "about" => "about_page#index"
  
  match "about" => "about_page#index"
  
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
  
  controller :buildings do
    post 'ajax_update' => :ajax_update
  end
end
