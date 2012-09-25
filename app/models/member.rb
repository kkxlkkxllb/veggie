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
#  role                   :string(255)
#  login                  :string(255)
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
  has_many :providers,:foreign_key => "user_id",:dependent => :destroy
  has_many :u_words
  
  EDIT_SIDENAV = %w{profile provider account}
  
  def admin?
    self.role == "admin"
  end
  
  def avatar
    p = self.providers.first
    p ? p.avatar : "icon/avatar.png"
  end
  
  def name
    p = self.providers.first
    p ? p.user_name : "veggie"
  end
  
  def has_provider?(p)
    self.providers.where(:provider => p).first
  end
  
  def has_u_word(w)
    self.u_words.where(:word_id => w.id).first
  end
  
  def self.generate(prefix = Time.now.to_f.to_s.split(".")[1])
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
