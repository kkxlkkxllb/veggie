# == Schema Information
#
# Table name: vote_fields
#
#  id              :integer          not null, primary key
#  content         :string(255)
#  vote_subject_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class VoteField < ActiveRecord::Base
  has_many :votes
  belongs_to :vote_subject
  validate :content, :presence => true
  validate :vote_subject_id, :presence => true
  
end
