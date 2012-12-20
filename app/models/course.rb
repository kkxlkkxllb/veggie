# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  ctags      :string(255)
#  language   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  ctags      :string(255)
#  language   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# course & mission
class Course < ActiveRecord::Base
  attr_accessible :ctags, :language, :title
end
