# coding: utf-8
class LeafsController < ApplicationController
  
  def index
    set_seo_meta("片语","17up,NGO,梦想,实践,未来","一起暸望新世界的风景")    
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
  
  def grow
    older = params[:older].blank?
    options = {}
    if params[:provider].to_i != 0
      options.merge!(:provider => Provider.find(params[:provider]))
    end
    Provider.build_leaf(older,options)
    render :json => {:status => 0}
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
