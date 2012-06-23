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

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
