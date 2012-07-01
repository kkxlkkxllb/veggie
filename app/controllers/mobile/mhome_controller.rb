# -*- coding: utf-8 -*-
class Mobile::MhomeController < ApplicationController
  layout 'mobile'
  def index
    set_seo_meta(nil,"17up,NGO,梦想,实践,未来","一起暸望新世界的风景")
  end
  
  def weibo
    @leafs = source_leafs(params[:pid],params[:page],12)
    if params[:pid]
      @users = ([Provider.find(params[:pid])] + Provider.all).uniq
    end
    respond_to do |format|
      format.html
			format.json{
			  render :json => {:status => 0,:msg => "ok",:data => {
        			:html => render_to_string(:layout => false, 
        			                             :template => "mobile/mhome/weibo.html.haml")
        }}
			}			
		end		
  end
  
  def learn_en
    @words = VoteSubject.words
    
    respond_to do |format|
		  format.html
			format.json{
				render :json => {:status => 0,:msg => "ok",:data => {
    			:html => render_to_string(:layout => false, 
    			                             :template => "mobile/mhome/learn_en.html.haml")
    		}}
			}		
		end
  end
end
