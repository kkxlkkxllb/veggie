# coding: utf-8
class LeafsController < ApplicationController
  before_filter :authenticate_member!,:except => :index
  def index
    set_seo_meta("片语",t('keywords'),t('describe'))    
    @leafs = source_leafs(params[:pid],params[:page],30)
    respond_to do |format|
      format.html
			format.json{
			  html = render_to_string(
		            :formats => :html,
                :handlers => :haml,
  			        :partial => "leafs"
  			        )
			  render_json(html)
			}			
		end
  end
  
  def destroy
    @leaf = Leaf.find(params[:id])
    if @leaf.destroy
      status = 0
    else
      status = -1
    end
    render :json => {:status => status}
  end
end
