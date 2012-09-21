class Greet

  def initialize(pid, opts={})
     @provider = Provider.find(pid)
     @motto = "I hear the call of the wild!"
     @content = "Hi,@#{@provider.user_name} " + I18n.t('greet.new_user',:num => @provider.member.id,:motto => @motto)
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


