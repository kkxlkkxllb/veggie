Veggie::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  mount Resque::Server, :at => "/resque"  

  devise_for :members, controllers: {
    omniauth_callbacks: :authentications,
    :sessions => :sessions
  }
  
  namespace :mobile do
    match '/' => "mhome#index"
    match "t" => "mhome#weibo",:as => :t
    match "learn_en" => "mhome#learn_en"
  end
  
  match "me" => "members#show",:as => :account
  match "u/:id" => "members#show",:as => :member

  resource :provider do
    post "create"
  end
  
  match "hot" => "home#hot", :as => :hot
  match "info" => "home#info", :as => :info
  
  resources :words
  
  match "t" => "leafs#index", :as => :leafs
  resources :leafs do
    post "destroy"
  end
 
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
