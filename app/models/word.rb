# == Schema Information
#
# Table name: words
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :string(255)
#  source     :string(255)      default("en"), not null
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Word < ActiveRecord::Base
  has_many :u_words
  
  validates :title, :presence => true, :uniqueness => true
  # 有ctag的words
  scope :vall, joins(:ctags).group("words.id")
  IMAGE_URL = "/system/images/word/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL
  
  acts_as_taggable
  acts_as_taggable_on :ctags
  after_create :make_pic
  
  class << self
    def parse_tag(str)
      str.scan(/\#(\S+)\s/).collect{|x| x[0]}
    end
    
    def tagged(tags)
      Word.tagged_with(tags,:any => true).all.uniq
    end
  end
  
  def source_link
    $dict_source[:english] + self.title
  end
  
  def source_voice
    $dict_source[:english_v] + self.title
  end
  
  def hash_tags
    self.ctags.map{|t| "#"+t.name+" " }.join
  end  
  
  def image(style="17up")
    url = IMAGE_URL + self.title + "/#{style}.jpg"
    path = IMAGE_PATH + self.title + "/#{style}.jpg"
    return File.exist?(path) ? url : "/assets/icon/jiong.png"
  end
  
  def make_pic
    HardWorker::WordPicJob.perform_async(self.title)
  end
  
end
