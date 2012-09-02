# -*- coding: utf-8 -*-
class ProviderController < ApplicationController
  
  def index
    
  end
  
  def auth
    hash = request.env["omniauth.auth"]
    provider = hash.provider
    uid = hash.uid
    token = hash.to_hash["credentials"]["token"]
    @provider = Provider.create(:provider => provider,:uid => uid,:token => token)
    render :json => @provider.to_json
  end
  
  def failure
    redirect_to "/404.html"
  end
  
  def create
    if Provider::PROVIDERS.include?(provider_params["provider"])
      @provider = Provider.create(provider_params)
    end
    if @provider
      status = 0
    else
      status = -1
    end
    render :json => {:status => status}
  end
  
  def destroy
    
  end
  
  private
  def provider_params
    params[:provider].slice(:provider,:uid)
  end
  
end
