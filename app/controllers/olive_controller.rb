class OliveController < ApplicationController
  before_filter :authenticate_admin
  
  def index
    set_seo_meta("Olive",t('keywords'),t('describe'))
  end
  
  def sync
    case params[:provider]
    when "tumblr"
      if params[:tag]
        @result = Olive::Tumblr.new.tagged(params[:tag])
      end
    when "instagram"
      if params[:tag]
        @result = Olive::InstagramVeg.new.tagged(params[:tag])
      elsif params[:location]
        @result = Olive::InstagramVeg.new.around(params[:location])
      else
        @result = Olive::InstagramVeg.new.popular
      end
    when "500px"
      if params[:tag]
        @result = Olive::Px.new.tagged(params[:tag])
      else
        @result = Olive::Px.new.photos(:feature => params[:feature])
      end
    end
    html = render_to_string(
            :formats => :html,
            :handlers => :haml,
		        :partial => "items"
		        )
    render_json(0,"ok",:html => html)
  end
  
  def publish
    data = params[:data]
    data.each do |p|  
      photo = JSON.parse(p)["photo"]
      caption = JSON.parse(p)["caption"]
      HardWorker::UploadOlive.perform_async(caption,open(photo).path)
    end
    render_json(0,"ok")
  end
  
  private
  def authenticate_admin
    unless current_member and current_member.admin?
      redirect_to root_path
    end
  end
end
