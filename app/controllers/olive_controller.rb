class OliveController < ApplicationController
  before_filter :authenticate_admin,:except => :fetch
  
  def index
    set_seo_meta("Olive",t('keywords'),t('describe'))
    @tags = Olive.parse_log
  end
  
  def sync
    case params[:provider]
    when "tumblr"
      if params[:tag]
        @result = Olive::Tumblr.new.tagged(params[:tag])
      end
    when "instagram"
      if params[:tag]
        @result = Olive::Instagram.new.tagged(params[:tag])
      elsif params[:location]
        @result = Olive::Instagram.new.around(params[:location])
      else
        @result = Olive::Instagram.new.popular
      end
    when "500px"
      if params[:tag]
        @result = Olive::Px.new.tagged(params[:tag])
      else
        @result = Olive::Px.new.photos(:feature => params[:feature])
      end
    end
    if @result and @result.length > 0
      html = render_to_string(
            :formats => :html,
            :handlers => :haml,
		        :partial => "items"
		        )
      render_json(0,"ok",:html => html)
    else
      render_json(-1,"fail")
    end
  end
  
  def publish
    data = params[:data]
    data.each do |p|  
      photo = JSON.parse(p)["photo"]
      caption = JSON.parse(p)["caption"]
			if file = open(photo)
      	HardWorker::UploadOlive.perform_async(caption,file.path)
			end
    end
    render_json(0,"ok",:num => data.length)
  end

  # Editor
	# input :id
	# cached
	def magic
	  @word = Word.find(params[:id])
		title = @word.title
    if params[:more]
		  @pics = Rails.cache.fetch("olive/#{title}",:expires_in => 5.hours) do
  			results = Parallel.map([Olive::Tumblr,Olive::Instagram,Olive::Px]) do |p|
  				photos(p,title)
  			end
  			results[0] + results[1] + results[2]
  		end
  	else
  	  opt = params[:ctag].blank? ? '' : @word.ctag_list.join(" ")
      @pics = Grape::WordImage.new(title).parse(opt)[0..14]
	  end

		render_json 0,"ok",@pics
	end
	
	# 当前用户关联身份下的相册图片
	# params: provider
	def fetch
	  if provider = current_member.has_provider?(params[:provider])
	    case provider.provider
      when 'instagram'
	      @result = Olive::Instagram.new(:access_token => provider.token).user_media_feed.map{|x| x[:photo]}
      when 'tumblr'
        @result = Olive::Tumblr.new.user_media(provider.metadata[:blogs][0][:name]+".tumblr.com")
      end
      if !@result.blank?   
        render_json 0,"ok",@result
      else
        render_json -1,"no content"
      end
    else
      render_json -2,"no provider"
    end	 
	end
  
  private
  def authenticate_admin
    unless current_member and current_member.admin?
      redirect_to new_member_session_path(:admin => 1)
    end
  end

	def photos(provider,title)
		provider.new.tagged(title).map{|x| x[:photo] }
	end
end
