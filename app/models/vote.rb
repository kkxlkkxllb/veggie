# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  vote_field_id :integer
#  user_ip       :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Vote < ActiveRecord::Base
  belongs_to :vote_field
  validate :vote_field_id, :presence => true
  validate :user_ip, :presence => true
  
  def is_allow
    self.vote_field.vote_subject.is_access?
  end
end
