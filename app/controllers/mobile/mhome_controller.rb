# -*- coding: utf-8 -*-
class Mobile::MhomeController < ApplicationController
  layout 'mobile/application'
  def index
    set_seo_meta("手机版",t('keywords'),t('describe'))
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
    @words = RWord.all
    
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
