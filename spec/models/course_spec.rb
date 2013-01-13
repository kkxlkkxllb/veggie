# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  ctags       :string(255)
#  language    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  member_id   :integer
#  description :text
#  status      :integer
#  weight      :integer
#  ctype       :integer
#

require 'spec_helper'

describe Course do
  pending "add some examples to (or delete) #{__FILE__}"
end
