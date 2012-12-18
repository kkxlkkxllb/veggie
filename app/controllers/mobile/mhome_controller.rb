class Mobile::MhomeController < ApplicationController
  layout 'mobile/application'
  caches_page :index
  
  def index
    set_seo_meta(t('mobile.title'),t('keywords'),t('describe'))
  end
  
  def weibo
    @leafs = source_leafs(params[:pid],params[:page],12)
    if params[:pid]
      @users = ([Provider.find(params[:pid])] + Provider.where("user_id is null")).uniq
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
  			cnt = @users ? @users.length : 0
			  render_json(0,"ok",{:html => html,:cnt => cnt})
			}			
		end		
  end
  
  def word
    @course = Course.first
    @ctags = @course.ctags.split(";")
    @tag = params[:ctag].blank? ? @ctags[0] : params[:ctag]
    RWord.build(@tag)
    @words = RWord.all(@tag)
    render_f = params[:ctag].blank? ? "mobile/mhome/word" : "mobile/word/_guess"
    respond_to do |format|
		  format.html
		  format.json{		    
		    html = render_to_string(
	            :layout => false,
	            :formats => :html,
              :handlers => :haml,
			        :file => render_f
			        )
			  render_json(0,"ok",{:html => html})
      }
		end
  end
end
