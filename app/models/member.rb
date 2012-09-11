# == Schema Information
#
# Table name: members
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable,
         :omniauthable, omniauth_providers: [:weibo,:twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :providers,:foreign_key => "user_id"
  
  def admin?
    self.role == "admin"
  end
  
  def self.generate(prefix)
    prefix ||= Time.now.to_f.to_s.split(".")[1]
    email = prefix + "@17up.org"
    passwd = "veggie"
    user = Member.new(:email => email,:password => passwd,:password_confirmation => passwd)
    if user.save!
      user
    else
      self.generate(prefix + "v")
    end
  end
  
end
