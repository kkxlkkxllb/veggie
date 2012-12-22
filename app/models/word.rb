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
  def image_path(opt={})
    name = opt[:w] ? "/w.png" : "/#{$config[:name]}.jpg"
    IMAGE_PATH + self.title.parameterize.underscore + name
  end

  def image_url(opt={})
    name = opt[:w] ? "/w.png" : "/#{$config[:name]}.jpg"
    IMAGE_URL + self.title.parameterize.underscore + name
  end

  def image
    return File.exist?(self.image_path) ? self.image_url : "/assets/icon/default.png"
  end

  def rich_images
    u_words.select{|w| w.has_image}.collect{|w| w.image}
  end

  def as_json
    { 
      :id => id,
      :title => title,
      :content => content
    }
  end

  def as_full_json
    as_json.merge({
        :tag_str => hash_tags,
        :audio => source_voice,
        :image => image,
        :tags => ctags.map(&:name)
      })
    # dimensions
  end
end
