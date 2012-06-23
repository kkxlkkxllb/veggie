# == Schema Information
#
# Table name: leafs
#
#  id          :integer         not null, primary key
#  content     :text
#  provider_id :integer
#  image_url   :string(255)
#  time_stamp  :datetime
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'test_helper'

class LeafTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
