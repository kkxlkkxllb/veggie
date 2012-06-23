Veggie::Application.routes.draw do
  
  get "vote_subject/index"

  get "vote_subject/new"

  get "vote_subject/create"

  mount Mobile::Engine => '/mobile',:as => 'mobile'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'  

  devise_for :members
  
  get "leafs/destroy"
  get "home/index"
  match "/p/:pid" => "home#index"
  match "users" => "home#users"
 
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
