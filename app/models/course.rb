# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  ctags       :string(255)
#  language    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  member_id   :integer
#  description :text
#  status      :integer
#  weight      :integer
#  ctype       :integer
#


# course & mission
class Course < ActiveRecord::Base
  attr_accessible :ctags, :language, :title,:description,:ctype,:status,:weight
  belongs_to :member
  
  CTYPE = {
    "1" => "official",
    "2" => "pro",
    "3" => "common"
  }
  # 1 : 官方课程 无member_id 限role=a
  # 2 : 教师课程 限role=e
  # 3 : 个人课程 
  CTYPE.each do |k,v|
    scope v.to_sym,where(["ctype = ?", k.to_i])
  end
  
  STATUS = {
    "1" => "open",
    "2" => "ready",
    "3" => "draft"
  }
  # 1 : 发布状态 不能被修改，否则变为 3
  # 2 : 审核状态 不能修改，－>1 ->3
  # 3 : 草稿状态 默认
  STATUS.each do |k,v|
    scope v.to_sym,where(["status = ?", k.to_i])
  end
  
  def self.hello
    Course.official.first
  end
  
  def check(member)
    $redis.hset(member.personal_key,"course",id)
    if ctype == 2
      self.weight = self.weight + 1
      self.save
    end
  end
  
  def words
    case ctype
    when 1
      Rails.cache.fetch("course/#{self.id}",:expires_in => 1.day) do 
        Word.tagged(self.ctags.split(";")).map(&:as_full_json)
      end
    when 2
      # c_words
    when 3
      # u_words
    end
  end
  
  def as_json
    super(:only => [:id,:title,:ctags,:language,:description]).merge("word_cnt" => words.length)
  end
end
