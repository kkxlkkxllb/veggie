# -*- coding: utf-8 -*-
class ProviderController < ApplicationController
  
  def create
    if Provider::PROVIDERS.include?(provider_params["provider"])
      @provider = Provider.create(provider_params)    
    end
    if @provider
      ResqueJob::GrowLeafJob.new.async(:grow, @provider.id)
      render_json(0,"ok")
    end
   
  end
  
  def destroy
    
  end
  
  private
  def provider_params
    params[:provider].slice(:provider,:uid)
  end
  
end
