# -*- coding: utf-8 -*-
module Mobile
  class MhomeController < ApplicationController
    def index
      set_seo_meta(nil,"17up,NGO,梦想,实践,未来","一起暸望新世界的风景")
      @source_leafs = params[:pid].blank? ? Leaf : Provider.find(params[:pid]).leafs
      @leafs = @source_leafs.order("time_stamp DESC").page(params[:page]).per(20)
      respond_to do |format|
  			format.json{
  				render :json => {:status => 0,:msg => "ok",:data => {
  					:html => render_to_string(:layout => false, 
  					                             :template => "mobile/home/_leafs.html.erb")
  				}}
  			}
  			format.html
  		end
    end
  end
end
