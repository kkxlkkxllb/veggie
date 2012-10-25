# coding: utf-8
class LeafsController < ApplicationController
  before_filter :authenticate_member!,:except => :index
  
  def index
    set_seo_meta(t('leafs.title'),t('leafs.keywords'),t('leafs.describe'))    
    @leafs = source_leafs(params[:pid],params[:page],30)
    respond_to do |format|
      format.html
			format.json{
			  html = render_to_string(
		            :formats => :html,
                :handlers => :haml,
  			        :partial => "leafs"
  			        )
			  render_json(0,"ok",{:html => html})
			}			
		end
  end
  
  def destroy  
    if @leaf = Leaf.find(params[:id])
      @leaf.destroy
      expire_page :action => :index
      render_json(0,"ok")
    end    
  end
end
