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
  
  acts_as_taggable
  acts_as_taggable_on :ctags
  
  class << self
    def parse_tag(str)
      str.scan(/\#(\S+)\s/).collect{|x| x[0]}
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
end
