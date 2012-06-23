require 'net/http'
require 'json'

class LeafGrow

  def initialize(provider)        
    @provider = provider
  end
  
  def grow(options = {})
    url = request_url(@provider)
    if !options.blank?  
      url = url + @provider.get_leafs(options[:older])    
    end
    resp = Net::HTTP.get_response(URI.parse(url)).body
		data = JSON.parse(resp)
		data.each do |d|		  
		  if @provider.metadata.blank?
		    @provider.metadata = user_info(d["user"],@provider)
		    @provider.save!
	    end
			Leaf.create(:provider_id => @provider.id,
			            :content => d["text"],
			            :time_stamp => Time.parse(d["created_at"]),
			            :image_url => get_image(d,@provider),
			            :weibo_id => d["id"])
		end
  end
  
  private
  def request_url(provider)
    case provider.provider
    when "weibo"
      @base_url = "http://api.t.sina.com.cn/statuses/user_timeline.json"
      @app_key = "2419359407"
      @feature = 1
      return "#{@base_url}?source=#{@app_key}&id=#{provider.uid}&feature=#{@feature}"
    when "twitter"
      @base_url = "http://api.twitter.com/1/statuses/user_timeline.json"
      return "#{@base_url}?screen_name=#{provider.uid}&include_entities=true"
    end
  end
  
  def get_image(data,provider)
    case provider.provider
    when 'weibo'
      return data["original_pic"]
    when 'twitter'
      return nil#data["entities"]["urls"]
    end  
  end
  
  def user_info(user,provider)
    case provider.provider
    when 'weibo'
      {
        :nickname => user['screen_name'],
        :name => user['name'],
        :location => user['location'],
        :image => user['profile_image_url'],
        :domain => user["domain"],
        :gender => user["gender"],
        :description => user['description'],
        :weibo_url => 'http://weibo.com/' + user['id'].to_s
      }
    when 'twitter'
      {
        :nickname => user['screen_name'],
        :name => user['name'],
        :location => user['location'],
        :image => user['profile_image_url'],
        :description => user['description'],
        :weibo_url => "https://twitter.com/#!/#{user['screen_name']}"
      }
    end
  end
end
