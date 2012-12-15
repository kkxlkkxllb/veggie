Veggie::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  #mount Resque::Server, :at => "/resque" 
  require 'sidekiq/web'
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.admin? }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :members, :controllers => {
    :omniauth_callbacks => :authentications,
    :sessions => :sessions
  }
  
  namespace :mobile do
    match '/' => "mhome#index"
    match "t" => "mhome#weibo",:as => :t
    match "word" => "mhome#word"
  end
  
  namespace :love do
    match '/' => "lhome#index"
  end
  
  # members
  match "dashboard" => "members#dashboard",:as => :account
  match "u/:id" => "members#show",:as => :member
  match "setting" => "members#edit",:as => :setting
  
  # home
  match "welcome" => "home#index", :as => :welcome
  match "square" => "home#square", :as => :hot
  match "info" => "home#info", :as => :info 
  match "quotes" => "home#quote", :as => :quote
  
	# words
  match "library" => "words#index", :as => :words
  match "c/:id" => "words#course", :as => :course
  resources :words do
    member do
      post "create"
      post "u_create"
      post "add_tag"
      post "clone"
      post "fetch_img"
    	post "upload_img"
    	post "select_img"
      post "destroy"
    end
  end
  
  # leafs
  match "t" => "leafs#index", :as => :leafs
  post "leafs/destroy"
  post "provider/create"
  
  # olive
  resources :olive do
    member do
      get "index"
      post "sync"
      post "publish"
      get "fetch"
    end
  end
 
  root :to => 'home#door'

  # See how all your routes lay out with "rake routes"
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
