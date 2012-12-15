module HardWorker
  class Base
    include Sidekiq::Worker
    sidekiq_options retry: false 
    
    def logger(msg)
      Logger.new(File.join(Rails.root,"log","sidekiq-job.log")).info("[#{self.class}] #{msg}")
    end
  end
    
  class SendGreetJob < Base          
    def perform(pid, opts={})
      self.logger(pid)
      Greet.new(pid,opts).deliver
    end
  end
  
  class SendNewLeafReport < Base
    def perform(nlc)  
      %w(weibo twitter).each do |p|
        Greet.new(nil,{:new_leaf_count => nlc,:provider => p}).deliver
      end
    end
  end
  
  class GrowLeafJob < Base
    def perform(pid, opts={})
      LeafGrow.new(Provider.find(pid)).grow
    end
  end
  
  class UploadOlive < Base
    def perform(content,pic)
      begin
        provider = Provider.find(38)
        client = Weibo::Client.new(provider.token,provider.uid)
        data = client.statuses_upload(content,pic)
				msg = data["error_code"] ? data.to_s : "#{data["id"]} published"
				self.logger msg
      rescue => ex
        self.logger("#{content} [#{pic}] fail msg: #{ex.to_s}")
      end
      #twitter
      veggie = Provider.find(35)
      client = Twitter::Client.new(
        :oauth_token => veggie.token,
        :oauth_token_secret => veggie.secret
      )
      client.update_with_media(content,File.open(pic))
    end
  end
  
end
