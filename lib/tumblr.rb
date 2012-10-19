require 'net/http'
require 'json'
require "open-uri"

class Tumblr
  include ActionView::Helpers::SanitizeHelper
  
  def initialize(pid=38)
    @pid = pid #weibo运营小号
    @api_key = YAML.load_file(Rails.root.join("config", "service.yml")).fetch(Rails.env)["tumblr"]["app_key"]
  end
  
  def tagged(tag)
    url = "http://api.tumblr.com/v2/tagged?tag=#{tag}&api_key=#{@api_key}"
    resp = Net::HTTP.get_response(URI.parse(url)).body
		data = JSON.parse(resp)
		if data["meta"]["status"] == 200
		  @post = []
		  data["response"].each do |t|
	      if t["type"] == "photo" and t["caption"] != ""
	        @post = @post<<{
	          :photo => t["photos"][0]["original_size"]["url"],
	          :caption => CGI::unescapeHTML(strip_tags(t["caption"])).split("\n")[0]
          }
	      end
	    end
	       
	    @post.each do |p|
	      HardWorker::UploadTumblr.perform_async(@pid,p[:caption],open(p[:photo]).path)
      end
	  end
  end
  
end