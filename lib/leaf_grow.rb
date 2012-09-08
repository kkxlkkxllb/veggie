require 'net/http'
require 'json'

class LeafGrow

  def initialize(provider)        
    @provider = provider
  end
  
  def grow(options = {})
    case @provider.provider
    when "weibo"
      veggie = Provider.where(:provider => "weibo").first
      if veggie
        client = Weibo::Client.new(veggie.token,veggie.uid)
        opt = {:uid => @provider.uid,:feature => "1"}
        if !options.blank?
          str = @provider.get_leafs(options[:older])
          opt.merge!(:since_id => str.split("=")[1])
        end
        data = client.statuses_user_timeline(opt)["statuses"]
      else
        data = []
      end    
    when "twitter"
      @base_url = "http://api.twitter.com/1/statuses/user_timeline.json"
      url = "#{@base_url}?screen_name=#{@provider.uid}&include_entities=true"
      if !options.blank?  
        url = url + @provider.get_leafs(options[:older])    
      end
      resp = Net::HTTP.get_response(URI.parse(url)).body
		  data = JSON.parse(resp)
    end
    
    begin     
		  data.each do |d|		  
		    if @provider.metadata.blank?
  		    @provider.metadata = user_info(d["user"],@provider)
  		    @provider.save!
  	    end
  			Leaf.create(:provider_id => @provider.id,
  			            :content => d["text"],
  			            :time_stamp => Time.parse(d["created_at"]),
  			            :image_url => get_image(d,@provider),
  			            :weibo_id => d["id"].to_i)
  		end
		rescue StandardError => x
		  Leaf.logger.error("ERROR provider:#{@provider.provider} msg:#{x}")
  	end
  end
  
  # twitter api test method
  def test(uid)
    url = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{uid}&include_entities=true"
    resp = Net::HTTP.get_response(URI.parse(url)).body
		data = JSON.parse(resp)
		data.each do |d|
		  #puts some data
	  end
	  return uid
  end
  
  private
  
  def get_image(data,provider)
    case provider.provider
    when 'weibo'
      return data["original_pic"]
    when 'twitter'
      return data["entities"]["media"][0]["media_url"] rescue nil
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
