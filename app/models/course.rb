# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  ctags      :string(255)
#  language   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


# course & mission
class Course < ActiveRecord::Base
  attr_accessible :ctags, :language, :title
  
  def check(member)
    $redis.hset(member.personal_key,"course",id)
  end
  
  def words
    Rails.cache.fetch("course/#{self.id}",:expires_in => 1.day) do 
      Word.tagged(self.ctags.split(";")).map(&:as_full_json)
    end
  end
  
  def as_json
    super(:only => [:id,:title,:ctags,:language]).merge("word_cnt" => words.length)
  end
end
