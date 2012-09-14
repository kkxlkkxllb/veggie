class Greet

  def initialize(pid, opts={})
     @provider = Provider.find(pid)
  end
  
  def deliver
    
  end
  
  def self.logger
    @greetlogger||=CustomLogger::Logger.new(File.join(Rails.root,"log","greet.log"))
  end
  
end
