class LeafGrow

  def initialize(provider)
    @provider = provider
    @veggie = Provider.where(["provider = ? AND user_id is not null",@provider.provider]).first
  end
  
  def grow(options = {})
    opt = {}
    if !options.blank?
      str = @provider.get_leafs(options[:older])
      opt.merge!(:since_id => str.split("=")[1])
    end 
    
    case @provider.provider
    when "weibo"
      opt.merge!(:uid => @provider.uid,:feature => "1")    
      client = Weibo::Client.new(@veggie.token,@veggie.uid)  
      Leaf.logger.info("NOTICE: start fetch weibo #{opt.to_a.join(',')}")    
      data = client.statuses_user_timeline(opt)["statuses"]  
    when "twitter"
      client = Twitter::Client.new(
        :oauth_token => @veggie.token,
        :oauth_token_secret => @veggie.secret
      )
      data = client.user_timeline(@provider.uid,opt)
    end
    
    complete(data)
  end
  
  def complete(data)
    begin     
		  data.each do |d|		  
		    if @provider.metadata.blank?
  		    @provider.metadata = user_info(d["user"],@provider)
  		    @provider.save!
  	    end
  			Leaf.create(:provider_id => @provider.id,
  			            :content => d["text"],
  			            :time_stamp => Time.parse(d["created_at"].to_s),
  			            :image_url => get_image(d,@provider),
  			            :weibo_id => d["id"])
  		end
		rescue StandardError => x
		  Leaf.logger.error("ERROR provider:#{@provider.provider} msg:#{x}")
  	end
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

class TumblrLeafGrow < LeafGrow
  
  def grow
    
  end
end