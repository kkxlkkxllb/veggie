class Greet

  def initialize(pid, opts={})
     @provider = Provider.find(pid)
     @content = "Hi,@#{@provider.user_name} " + t('greet.new_user',:num => @provider.member.id)
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
    end    
    Greet.logger(data['id'].to_s + "send greet success to #{@provider.user_name}")
  end
  
 
  
  def self.logger(msg)
    Logger.new(File.join(Rails.root,"log","greet.log")).info("[#{Time.now.to_s}]" + msg.to_s)
  end
  
end

class Weather < Greet
  def initialize(pid, opts={})
     super
     @content = "@"
  end
  
end
