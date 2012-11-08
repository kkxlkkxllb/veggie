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
      Greet.new(pid).deliver
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
  
  class WordPicJob < Base
    def perform(title)
      Grape::WordImage.new(title).make
    end   
  end
  
  class UploadOlive < Base
    def perform(content,pic)
      provider = Provider.find(38)
      client = Weibo::Client.new(provider.token,provider.uid)
      data = client.statuses_upload(content,pic)
      self.logger(data["id"].to_s + " published to #{provider.user_name}")
      #twitter
      #update_with_media
    end
  end
  
end