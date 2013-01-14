module Wheat
  class Base
    include ActionView::Helpers::SanitizeHelper

    def initialize(provider)
      @provider = provider     
    end

    # in Provider::PROVIDERS
    def veggie(provider_name)
      Provider.where(["provider = ? AND user_id is not null",provider_name]).first
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

    def get_image(data,provider)
      case provider.provider_type
      when 'weibo'
        return data["original_pic"]
      when 'twitter'
        return data["entities"]["media"][0]["media_url"] rescue nil
      when 'tumblr'
        return data["photos"][0]["original_size"]["url"] rescue nil
      end  
    end
    
    def user_info(user,provider)
      case provider.provider_type
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

  class Weibo < Base
    def initialize(provider)
      super
      @veggie = veggie("weibo")
      @client = ::Weibo::Client.new(@veggie.token,@veggie.uid)
    end

    def grow(options = {})
      opt = {}
      if options.has_key?(:older)
        str = @provider.get_leafs(options[:older])
        opt.merge!(:since_id => str.split("=")[1])
      end 

      opt.merge!(:uid => @provider.uid,:feature => "1")           
      Leaf.logger.info("NOTICE: start fetch weibo #{opt.to_a.join(',')}")    
      data = @client.statuses_user_timeline(opt)["statuses"]  

      complete(data)
    end
  end

  class Twitter < Base
    def initialize(provider)
      super
      @veggie = veggie("twitter")
      @client = ::Twitter::Client.new(
        :oauth_token => @veggie.token,
        :oauth_token_secret => @veggie.secret
      )
    end

    def grow(options = {})
      opt = {}
      if options.has_key?(:older)
        str = @provider.get_leafs(options[:older])
        opt.merge!(:since_id => str.split("=")[1])
      end 
    
      data = @client.user_timeline(@provider.uid,opt)

      complete(data)
    end
  end

  class Tumblr < Base

    def initialize(provider)
      super
      @veggie = veggie("tumblr")
      @client = ::Tumblr.new(
          :oauth_token => @veggie.token,
          :oauth_token_secret => @veggie.secret
        )
      @blog_name = "#{@provider.uid}.tumblr.com"
    end
    
    def look
      @client.posts(@blog_name,:type => "photo")
    end
    
    def grow(options = {})
      opt = {
        :type => "photo"
      }.update(options)
      data = @client.posts(@blog_name,opt)
      begin     
        data["posts"].each do |d|      
          if @provider.metadata.blank?
            @provider.metadata = user_info(data["blog"])
            @provider.save!
          end
          grow = true
          timestamp = Time.at(d["timestamp"].to_i)
          if options.has_key?(:older)
            if timestamp < Time.now - 1.day
              grow = false
            end
          end
          if grow
            Leaf.create(:provider_id => @provider.id,
                      :content => CGI::unescapeHTML(strip_tags(d["caption"])),
                      :time_stamp => timestamp,
                      :image_url => get_image(d,@provider),
                      :weibo_id => d["id"])
          end
        end
      rescue StandardError => x
        Leaf.logger.error("ERROR provider:tumblr msg:#{x}")
      end
    end

    def user_info(data)
      {
        :nickname => data['name'],
        :name => data['name'],
        :title => data['title'],
        :description => data['description'],
        :posts => data['posts'],
        :image => @client.avatar(@blog_name)['avatar_url'],
        :url => data["url"]
      }
    end
  end

end