# Fetch Pics Then Upload to SNS
module Olive
  SIDENAV = %w{tumblr instagram 500px}
  
  class Base
    include ActionView::Helpers::SanitizeHelper    
    
    def load_service
      YAML.load_file(Rails.root.join("config", "service.yml")).fetch(Rails.env)
    end
    
    def logger(msg)
      Logger.new(File.join(Rails.root,"log","olive.log")).info("[#{Time.now.to_s}]" + msg.to_s)
    end
    
    # google map place search by text,get lat&lng
    def location(query)
      query = URI.encode query
      key = load_service["google"]["api_key"]
      request_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{query}&key=#{key}&sensor=true"
      url = URI.parse(request_url)
	    response = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
				http.request(Net::HTTP::Get.new(request_url)) 
			end
			data = JSON.parse(response.body)["results"][0]
			{
			  :address => data["formatted_address"],
			  :lat => data["geometry"]["location"]["lat"],
			  :lng => data["geometry"]["location"]["lng"]
			}
    end
    
    # upload to weibo
    def upload(tag = "")
      @data = block_given? ? yield(self) : tagged(tag)
      @data.each do |p|     
        HardWorker::UploadOlive.perform_async(p[:caption],open(p[:photo]).path)
      end
    end
  end
  
  class Tumblr < Base

    def initialize(opts={})
      veggie = Provider.where(:provider => "tumblr").first
      opts = {
        :oauth_token => veggie.token,
        :oauth_token_secret => veggie.secret
      }.update(opts)
      
      @client = ::Tumblr.new(opts)
    end

    def tagged(tag)
      tag = URI.encode tag
      data = @client.tagged tag		  
		  @post = data.inject([]) do |a,t|
	      if t["type"] == "photo" and t["caption"] != ""
	        a<<{
	          :photo => t["photos"][0]["original_size"]["url"],
	          :caption => CGI::unescapeHTML(strip_tags(t["caption"])).split("\n")[0]
          }
	      end
	      a
	    end
	    logger("From Tumblr --  Num: #{@post.length}; Tag: #{tag}")

	    return @post
    end
    
    def magic(blog_name)
      data = @client.posts(blog_name,:type => "photo")["posts"]
      data.inject([]) do |result,d|
        result << d["photos"][0]["original_size"]["url"].sub(/_\d+\./,"_400.")
        result
      end
    end
  
  end
  
  class Instagram < Base
    
    def initialize(opts={})
			# :access_token
      @client = ::Instagram.client(opts)
    end
    
    def tagged(tag)
      resp = @client.tag_recent_media(tag)
      @post = get_post(resp.data)
      logger("From Instagram --  Num: #{@post.length}; Tag: #{tag}")
      
      return @post
    end
    
    def popular
      resp = @client.media_popular
      @post = get_post(resp)
    end
    
    def around(query)
      location = location(query)
      resp = @client.media_search(location[:lat].to_s,location[:lng].to_s)
      @post = get_post(resp.data)
      logger("From Instagram --  Num: #{@post.length}; location: #{location[:address]}")
      
      return @post
    end
    
    # return lat/lng/id/name
    def location_search(query,opts={})
      if query
        location = location(query)
        data = @client.location_search(location[:lat].to_s,location[:lng].to_s)
      else
        data = @client.location_search(opts[:lat].to_s,opts[:lng].to_s)
      end
      data.to_json
    end
    
    def location_recent_media(id)
      resp = @client.location_recent_media(id.to_i)
      @post = get_post(resp.data)
    end

		def user_media_feed
			resp = @client.user_media_feed
			@post = get_post(resp)
		end
    
    private
    def get_post(data)
			if data.is_a?(Array)
		    data.map do |x|    
					caption = x.caption ? x.caption.text : ""
		      {
		        :photo => x.images.standard_resolution.url,
		        :caption => caption
		      }
		    end
			end
    end
    
  end
  
  # methods
  # 1-photos
  # 2-tagged(tag)
  class Px < Base
		#require 'openssl'
    BASE_URL = 'https://api.500px.com'

    def initialize
      px = load_service["500px"]
      @ckey = px["app_key"]
      @csecret = px["app_secret"]
      @uname = px["user_name"]
      @pwd = px["password"]      
    end
    
    def photos(opt={})
    	options = {
    	  :image_size => 4,
				:feature => 'fresh_today'#'popular'/'upcoming'/'editors'
			}
			options.merge!(opt)
			@request = "/v1/photos?"+options.to_query
			@photos = get_photos(@request)
		end
		
		def tagged(tag,opt={})
		  options = {
		    :term => tag,
		    :image_size => 4
		  }
		  options.merge!(opt)
		  @request = "/v1/photos/search?"+options.to_query
		  @photos = get_photos(@request)
		end

		def get_access_token
			consumer = OAuth::Consumer.new(@ckey, @csecret, {
			:site               => BASE_URL,
			:request_token_path => "/v1/oauth/request_token",
			:access_token_path  => "/v1/oauth/access_token",
			:authorize_path     => "/v1/oauth/authorize"})

			request_token = consumer.get_request_token()
			#p "Request URL: #{request_token.authorize_url}"
			access_token = consumer.get_access_token(request_token, {}, { :x_auth_mode => 'client_auth', :x_auth_username => @uname, :x_auth_password => @pwd })
			access_token
		end

		def user
			access_token = get_access_token
			p "token: #{access_token.token}" 
			p "secret: #{access_token.secret}" 
			p MultiJson.decode(access_token.get('/v1/users.json').body)
		end
		
		private
		def get_photos(request)
		  access_token = get_access_token
			data = MultiJson.decode(access_token.get(request).body)["photos"]
			data.inject([]) do |a,x| 
				a << {
					:caption => x["name"],
					:photo => x["image_url"]
				}
			end
		end
  end
  
  # 根据 olive 日志信息得到 最近100次搜索的 tag,按照次数降序返回结果
  def self.parse_log
    log = "#{Rails.root}/log/olive.log"
    if File.exist? log
      tags = File.open(log,"r") do |f|		
    		f.readlines[-100..-1].map {|l| l.scan(/Tag\: (\S+)/).map{|x| $1}[0]	}		
    	end.compact
    	tags.uniq.map{ |x| 
    		[x,tags.grep(x).length]
    	}.sort!{|a,b| b[1] <=> a[1]}
		else
			[]
  	end
  end
  
end
