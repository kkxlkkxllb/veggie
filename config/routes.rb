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
  
  match "dashboard" => "members#show",:as => :account
  match "u/:id" => "members#show",:as => :member
  match "setting" => "members#edit",:as => :setting

	post "provider/create"
  
  match "welcome" => "home#index", :as => :welcome
  match "square" => "home#square", :as => :hot
  match "info" => "home#info", :as => :info
  match "course" => "words#index", :as => :words
  match "quotes" => "home#quote", :as => :quote
  
	# words
  post "words/create"
  post "words/u_create"
  post "words/add_tag"
  post "words/clone"
  post "words/fetch_img"
	post "words/upload_img"
	post "words/select_img"
  
  match "t" => "leafs#index", :as => :leafs
  match "leafs/destroy" => "leafs#destroy"
  
  match "olive" => "olive#index"
  match "olive/sync" => "olive#sync"
  match "olive/publish" => "olive#publish"
	get "olive/fetch"
 
  root :to => 'home#door'

  # See how all your routes lay out with "rake routes"
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
