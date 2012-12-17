class ProviderController < ApplicationController
  
  def create
    if Provider::PROVIDERS.include?(provider_params["provider"])
      @provider = Provider.create(:uid => provider_params["uid"],
                                  :provider => provider_params["provider"]+"_#{$config[:name]}")    
    end
    if @provider
      HardWorker::GrowLeafJob.perform_async(@provider.id)
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
