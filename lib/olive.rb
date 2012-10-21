require 'net/http'
require 'json'
require "open-uri"

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
    def upload(tag)     
      tagged(tag).each do |p|
	      HardWorker::UploadTumblr.perform_async(ASSIST,p[:caption],open(p[:photo]).path)
      end
    end
  end
  
  class Tumblr < Base

    def initialize      
      @api_key = load_service["tumblr"]["app_key"]
      @tm = Date.today.to_time.to_i
    end

    def tagged(tag)
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
    
    def tagged(tag)
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
  
end