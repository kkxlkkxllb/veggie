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

require 'test_helper'

class VoteSubjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
