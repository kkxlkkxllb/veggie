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
  
  # home
  match "welcome" => "home#index", :as => :welcome
  match "square" => "home#square", :as => :hot
  match "info" => "home#info", :as => :info 
  match "quotes" => "home#quote", :as => :quote
  
	# words
  match "library" => "words#index", :as => :words
  match "c/:id" => "words#course", :as => :course
  namespace :words do
    post "create"
    post "u_create"
    post "add_tag"
    post "clone"
    post "fetch_img"
  	post "upload_img"
  	post "select_img"
    post "destroy"
  end
  
  # leafs
  match "t" => "leafs#index", :as => :leafs
  post "leafs/destroy"
  post "provider/create"
  
  # olive
  match "o" => "olive#index", :as => :olive
  namespace :olive do
    post "sync"
    post "publish"
    get "fetch"
  end

  # members
  match "dashboard" => "members#dashboard",:as => :account  
  match "setting" => "members#edit",:as => :setting
  match ":role/:uid" => "members#show"
 
  root :to => 'home#door'

  # See how all your routes lay out with "rake routes"
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
