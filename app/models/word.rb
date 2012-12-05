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
  scope :has_tag, joins(:ctags).group("words.id")
  IMAGE_URL = "/system/images/word/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL
  
  acts_as_taggable
  acts_as_taggable_on :ctags
  
  class << self
    def parse_tag(str)
      str.scan(/\#(\S+)\s/).collect{|x| x[0]}
    end
    
    def tagged(tags)
      Word.tagged_with(tags,:any => true).all.uniq
    end

  end
  
  def source_link
    $dict_source[:english] + URI.encode(self.title)
  end
  
  def source_voice
    $dict_source[:english_v] + URI.encode(self.title)
  end
  
  def hash_tags
    self.ctags.map{|t| "#"+t.name+" " }.join
  end  
  
  # style: 17up/original
  def image_path(style="17up")
    IMAGE_PATH + self.title.parameterize.underscore + "/#{style}.jpg" 
  end

  def image_url(style="17up")
    IMAGE_URL + self.title.parameterize.underscore + "/#{style}.jpg" 
  end

  def image
    return File.exist?(self.image_path) ? self.image_url : "/assets/icon/default.png"
  end

  def as_json
		{
			:t => self.class.to_s,
			:title => self.title,
			:id => self.id
		}
	end
end
