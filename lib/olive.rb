# Fetch Pics Then Upload to SNS
module Olive
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

    def initialize      
      @api_key = load_service["tumblr"]["app_key"]
      @tm = Date.today.to_time.to_i
    end

    def tagged(tag,skip_tm = false)
      @tm = skip_tm ? 0 : @tm
      url = "http://api.tumblr.com/v2/tagged?tag=#{tag}&api_key=#{@api_key}"
      resp = Net::HTTP.get_response(URI.parse(url)).body
  		data = JSON.parse(resp)
  		if data["meta"]["status"] == 200 		  
  		  @post = data["response"].inject([]) do |a,t|
  	      if t["type"] == "photo" and t["caption"] != "" and t["timestamp"] > @tm
  	        a<<{
  	          :photo => t["photos"][0]["original_size"]["url"],
  	          :caption => CGI::unescapeHTML(strip_tags(t["caption"])).split("\n")[0]
            }
  	      end
  	      a
  	    end
  	    logger("From Tumblr -- Time: #{@tm}; Num: #{@post.length}; Tag: #{tag}")

  	    return @post
  	  end
    end
  
  end
  
  class InstagramVeg < Base
    
    def initialize
      insta = load_service['instagram']
      opt = {
        :client_id => insta["client_id"],
        :client_secrect => insta["client_secrect"]
      }
      @client = Instagram::Client.new(opt)
      @tm = Date.today.to_time.to_i
    end
    
    def tagged(tag,skip_tm = false)
      @tm = skip_tm ? 0 : @tm
      resp = @client.tag_recent_media(tag)
      @post = get_post(resp.data,@tm)
      logger("From Instagram -- Time: #{@tm}; Num: #{@post.length}; Tag: #{tag}")
      
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
    
    private
    def get_post(data,tm = 0)
      data.inject([]) do |a,x| 
        if x.caption and x.created_time.to_i > tm
          a<<{
            :photo => x.images.standard_resolution.url,
            :caption => x.caption.text
          }
        end
        a
      end
    end
    
  end
  
  # methods
  # 1-photos
  # 2-tagged(tag)
  class Px < Base
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
					:caption => x["name"] + " #500px# ",
					:photo => x["image_url"]
				}
			end
		end
  end
  
end