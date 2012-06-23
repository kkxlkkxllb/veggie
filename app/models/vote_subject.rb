# == Schema Information
#
# Table name: vote_subjects
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  key_id     :integer
#  end_time   :datetime
#  limit_num  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VoteSubject < ActiveRecord::Base
  has_many :vote_fields
  has_many :votes, :through => :vote_fields
  validate :title, :presence => true
  # 问答形式的
  scope :as_answer, :conditions => ["key_id IS NOT NULL"]
  # 投票形式的
  scope :as_vote, :conditions => ["key_id IS NULL"]
  # 允许公开投票的
  scope :access, :conditions => ["(end_time IS NULL or end_time > ?) AND limit_num IS NULL",Time.current]

  acts_as_taggable
  acts_as_taggable_on :subject
  
  def is_access?
    (end_time == nil or end_time > Time.now)&&(limit_num == nil or limit_num > votes.size)
  end
  
end
