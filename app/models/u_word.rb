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
  # attr_accessible :title, :body
  belongs_to :member
  belongs_to :word
  
  validates :member_id, :presence => true, :uniqueness => {:scope => :word_id }
  
  acts_as_taggable
  acts_as_taggable_on :ctags
end
