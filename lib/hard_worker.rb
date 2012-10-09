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
  
  class GrowLeafJob < Base
    def perform(pid, opts={})
      LeafGrow.new(Provider.find(pid)).grow
    end
  end
  
end