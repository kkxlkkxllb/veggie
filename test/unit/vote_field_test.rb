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

require 'test_helper'

class VoteFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
