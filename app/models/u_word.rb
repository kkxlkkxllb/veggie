# == Schema Information
#
# Table name: u_words
#
#  id         :integer          not null, primary key
#  member_id  :integer          not null
#  word_id    :integer          not null
#  content    :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UWord < ActiveRecord::Base
  belongs_to :member
  belongs_to :word
  
  validates :member_id, :presence => true, :uniqueness => {:scope => :word_id }
  
  acts_as_taggable
  acts_as_taggable_on :ctags
  
  IMAGE_URL = "/system/images/u_word/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL

	class << self   
    def tagged(tags)
      UWord.tagged_with(tags,:any => true).all.uniq
    end
  end
  
  def title
    self.word.title
  end
  
  def content
    self.word.content
  end
  
  def image_path(style="17up")
    IMAGE_PATH + "#{self.id}/#{style}.jpg"
  end
  
  def image_url(style="17up")
    IMAGE_URL + "#{self.id}/#{style}.jpg"
  end
  
  def image
    return File.exist?(self.image_path) ? self.image_url : "/assets/icon/jiong.png"
  end

	def untagged(user)
		words = user.u_words
		words - words.joins(:ctags).group("u_words.id")
	end
  
end
