module ResqueJob
  
  class Base
    # This will be called by a worker when a job needs to be processed
    DEFAULT_QUEUE = :low
    def self.perform(method, *args)
      self.instance.send(method, *args)		
    end
    
    def self.instance
       self.new
    end
    
    def self.queue
      DEFAULT_QUEUE
    end
    
    def self.rlogger
      @logger = Logger.new(File.join(Rails.root,"log","resque-job.log"))
    end
    
    def rlogger
      self.class.rlogger
    end
    
    def log(msg)
      rlogger.info("[#{self.class}] #{msg}")
    end

    # We can pass this any Repository instance method that we want to
    # run later.
    
    def async(method, *args)
      Rails.logger.info("Resque.enqueue:#{self.class},#{method}, #{args.inspect}")
      Resque.enqueue(self.class, method, *args)
    end
  end
    
  class SendGreetJob < Base
    @queue = :high
    def greet(pid, opts={})
      Greet.new(pid).deliver
    end
  end
  
  class GrowLeafJob < Base
    @queue = :high
    def grow(pid, opts={})
      LeafGrow.new(Provider.find(pid)).grow
    end
  end
  
end