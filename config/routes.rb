PowerStorm::Application.routes.draw do
  get "admin" => 'admin#index'
  
  resources :users
  resources :weathers
  resources :electricity_readings
  resources :meters
  resources :buildings
  
  root :to => 'Buildings#index', :as => 'buildings'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
end
