# -*- coding: utf-8 -*-
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
  has_many :vote_fields,:dependent => :destroy
  has_many :votes, :through => :vote_fields
  validate :title, :presence => true
  # 问答形式的
  scope :as_answer, :conditions => ["key_id IS NOT NULL"]
  # 投票形式的
  scope :as_vote, :conditions => ["key_id IS NULL"]
  # 允许公开投票的
  scope :access, :conditions => ["(end_time IS NULL or end_time > ?) AND limit_num IS NULL",Time.current]

  acts_as_taggable
  acts_as_taggable_on :subjects
  
  def is_access?
    (end_time == nil or end_time > Time.now)&&(limit_num == nil or limit_num > votes.size)
  end
  
  def self.words
    VoteSubject.tagged_with("英语词汇")
  end
  
  # 生产随机3个错误选项
  def word_guess
    guess = []
    rest = VoteField.where(["vote_subject_id != ?",self.id]).all
    3.times do 
      num = rand(rest.size)
      guess << rest[num]
      rest.delete_at(num)
    end
    return guess.insert(rand(4)-1,self.vote_fields.first)
  end
  
end
