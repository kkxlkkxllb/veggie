# == Schema Information
#
# Table name: providers
#
#  id         :integer          not null, primary key
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  token      :string(255)
#  secret     :string(255)
#  metadata   :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
