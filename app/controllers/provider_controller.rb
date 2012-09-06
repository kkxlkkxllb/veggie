# -*- coding: utf-8 -*-
class ProviderController < ApplicationController
  
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
