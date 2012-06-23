# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  before_filter :redirect_mobile,:only => :index
  def index
    set_seo_meta(nil,"17up,NGO,梦想,实践,未来","一起暸望新世界的风景")
    @source_leafs = params[:pid].blank? ? Leaf : Provider.find(params[:pid]).leafs
    @leafs = @source_leafs.order("time_stamp DESC").page(params[:page]).per(30)
    respond_to do |format|
			format.json{
				render :json => {:status => 0,:msg => "ok",:data => {
					:html => render_to_string(:layout => false, 
					                             :template => "home/_leafs.html.erb")
				}}
			}
			format.html
		end
  end
  
  def users
    set_seo_meta("名将录","17up,NGO,梦想,实践,未来","一起暸望新世界的风景")
    @users = Provider.all
  end
  
  def lab
    
  end
  
  private
  
  def redirect_mobile
    if request.user_agent.downcase.include?("iphone")
      redirect_to "/mobile"
    end
  end
end
