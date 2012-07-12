Veggie::Application.routes.draw do
  match "/application.manifest" => Rails::Offline
  
  get "vote_subject/index"

  get "vote_subject/new"

  get "vote_subject/create"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'  

  devise_for :members
  
  namespace :mobile do
    match '/' => "mhome#index"
    match "mweibo" => "mhome#weibo"
    match "learn_en" => "mhome#learn_en"
  end
  
  get "leafs/destroy"
  get "home/index"
  match "/p/:pid" => "home#index"
  match "users" => "home#users"
  match "word/insert" => "vote_subject#insert_word"
 
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
