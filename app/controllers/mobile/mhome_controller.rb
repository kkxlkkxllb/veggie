# -*- coding: utf-8 -*-
class Mobile::MhomeController < ApplicationController
  layout 'mobile/application'
  def index
    set_seo_meta("手机版","17up,NGO,梦想,实践,未来,教育","一起暸望新世界的风景，创新的育人方式")
  end
  
  def weibo
    @leafs = source_leafs(params[:pid],params[:page],12)
    if params[:pid]
      @users = ([Provider.find(params[:pid])] + Provider.all).uniq
    end
    respond_to do |format|
      format.html
			format.json{
			  html = render_to_string(
			          :layout => false,
		            :formats => :html,
                :handlers => :haml,
  			        :file => "mobile/mhome/weibo"
  			        )
			  render_json(html)
			}			
		end		
  end
  
  def learn_en
    @words = Word.all
    
    respond_to do |format|
		  format.html
		  format.json{
		    html = render_to_string(
		            :layout => false,
		            :formats => :html,
                :handlers => :haml,
  			        :file => "mobile/mhome/learn_en"
  			        )
			  render_json(html)
      }
		end
  end
end
