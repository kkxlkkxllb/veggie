class Greet

  def initialize(pid, opts={})
    if pid.blank?
      @provider = Member.first.providers.where(:provider => opts[:provider]).first
      @content = I18n.t('greet.new_leafs',:num => opts[:new_leaf_count],:cast => Utils.check_weather)
    else
      greet = YAML.load_file(Rails.root.join("lib/cherry", "greet.yml")).fetch("greet")   
      @provider = Provider.find(pid)
      @motto = greet[rand(greet.length)]
      if opts[:bind]
        @content = I18n.t('greet.bind_provider',:name =>@provider.user_name,:motto => @motto)
      else
        @content = I18n.t('greet.new_user',:name =>@provider.user_name,:num => @provider.member.id,:motto => @motto)
      end
    end
  end
  
  def deliver
    veggie = Provider.where(["provider = ? AND user_id is not null",@provider.provider]).first
    case @provider.provider
    when "weibo"  
      client = Weibo::Client.new(veggie.token,veggie.uid)      
      data = client.statuses_update(@content)
    when "twitter"
      client = Twitter::Client.new(
        :oauth_token => veggie.token,
        :oauth_token_secret => veggie.secret
      )
      data = client.update(@content)
    when "github"
      github = Github.new oauth_token: veggie.token
      github.users.followers.follow @provider.user_name
    end    
    if data
      Greet.logger(data['id'].to_s + " send greet success to #{@provider.user_name}")
    end
  end 
  
  def self.logger(msg)
    Logger.new(File.join(Rails.root,"log","greet.log")).info("[#{Time.now.to_s}]" + msg.to_s)
  end
  
end


