class LeafsController < ApplicationController
  
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
