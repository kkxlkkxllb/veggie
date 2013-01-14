# == Schema Information
#
# Table name: words
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :string(255)
#  source     :string(255)      default("en"), not null
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Word do
  pending "add some examples to (or delete) #{__FILE__}"
end
