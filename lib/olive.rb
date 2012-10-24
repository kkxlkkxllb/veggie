#tagged resource from [Tumblr/Instagram]
module Olive
  class Base
    include ActionView::Helpers::SanitizeHelper
    ASSIST = 38
    
    def load_service
      YAML.load_file(Rails.root.join("config", "service.yml")).fetch(Rails.env)
    end
    
    def logger(msg)
      Logger.new(File.join(Rails.root,"log","olive.log")).info("[#{Time.now.to_s}]" + msg.to_s)
    end
    
    # upload to weibo
    def upload(tag,skip_tm = false)     
      tagged(tag,skip_tm).each do |p|
	      HardWorker::UploadOlive.perform_async(ASSIST,p[:caption],open(p[:photo]).path)
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
      @post = resp.data.inject([]) do |a,x| 
        if x.caption and x.created_time.to_i > @tm
          a<<{
            :photo => x.images.standard_resolution.url,
            :caption => x.caption.text
          }
        end
        a
      end
      logger("From Instagram -- Time: #{@tm}; Num: #{@post.length}; Tag: #{tag}")
      
      return @post
    end
    
  end
  
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
				:feature => 'popular'
			}
			options.merge!(opt)
			@request = "/v1/photos?"+options.to_query
			access_token = get_access_token
			data = MultiJson.decode(access_token.get(@request).body)["photos"]
			@photos = data.inject([]) do |a,x| 
				a << {
					:name => x["name"],
					:description => x["description"],
					:url => x["image_url"].sub("2.jpg","4.jpg")
				}
			end

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
  end
  
end