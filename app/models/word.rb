class Word
  attr_accessor :title,:content
  EN_KEY = "word:en"
  JA_KET = "word:japan"
  
  def initialize(title,content)
    @title = title
    @content = content
  end
  
  def self.create(title,content)
    $redis.hset(EN_KEY,title,content)
    return Word.new(title,content)
  end
  
  def del
    $redis.hdel(EN_KEY,self.title)
  end
  
  def self.find(title)
    if $redis.hexists(EN_KEY,title)
      Word.new(title,$redis.hget(EN_KEY,title))
    end
  end
  
  def self.word_plain
    $redis.hvals(EN_KEY)
  end
  
  def self.all(except = nil)
    all = $redis.hgetall(EN_KEY)
    if except
      all.delete(except)
    end
    all.map{|k,v| Word.new(k,v)}
  end
    
  # 生产随机3个错误选项
  def word_guess
    rest = Word.all(self.title)
    return (rest.shuffle[0..2] << self).shuffle
  end
  
end