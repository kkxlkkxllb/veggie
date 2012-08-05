Veggie::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'  

  devise_for :members
  
  namespace :mobile do
    match "/application.manifest" => Rails::Offline
    match '/' => "mhome#index"
    match "mweibo" => "mhome#weibo"
    match "learn_en" => "mhome#learn_en"
  end

  get "home/index"
  get "home/users"

  resources :words
  resources :leafs do
    post "grow"
    post "destroy"
  end
 
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
