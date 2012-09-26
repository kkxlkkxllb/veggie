class RWord
  attr_accessor :title,:content
  EN_KEY = "words:fruit"
  
  def initialize(title,content)
    @title = title
    @content = content
  end
  
  def self.build(key_word)
    key = "words:#{key_word}"
 
    @words = Word.tagged(key_word)
    $redis.hmset(key,@words.map{|x| [x.title,x.content]}.flatten)

  end
  
  def self.all(except = nil)
    
    all = $redis.hgetall(EN_KEY)
    if except
      all.delete(except)
    end
    all.map{|k,v| RWord.new(k,v)}
  end
  
  def source_link
    $dict_source[:english] + self.title
  end
  
  def source_voice
    $dict_source[:english_v] + self.title
  end
    
  # 生产随机3个错误选项
  def word_guess
    rest = RWord.all(self.title)
    return (rest.shuffle[0..2] << self).shuffle
  end
  
end