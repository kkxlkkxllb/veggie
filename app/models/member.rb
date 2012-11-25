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
#  uid                    :string(255)
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
         :omniauthable, omniauth_providers: [:weibo,:twitter,:github,:tumblr,:instagram,:youtube]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :providers,:foreign_key => "user_id",:dependent => :destroy
  has_many :u_words
  after_create :send_greet
  
  EDIT_SIDENAV = %w{profile provider account}
  AVATAR_URL = "/system/images/member/"
  AVATAR_PATH = "#{Rails.root}/public"+AVATAR_URL
  
  def admin?
    self.role == "admin"
  end
  
  def avatar
		File.exist?(AVATAR_PATH + avatar_name) ? (AVATAR_URL + avatar_name) : "icon/avatar.png"
  end

	def avatar_name
		"#{self.id}/#{self.created_at.to_i}.jpg"
	end
  
	# to-do
  # add profile
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
    user = Member.new(
      :email => email,
      :password => passwd,
      :password_confirmation => passwd,
      :role => "u")
    if user.save!
      user
    else
      self.generate(prefix + "v")
    end
  end
  
  # sidekiq job
  def send_greet
		provider = self.providers.first
		# download sns avatar
		`mkdir -p #{AVATAR_PATH + self.id.to_s}`
		data = open(provider.avatar(:large)){|f|f.read}
		file = File.open(AVATAR_PATH + avatar_name,"wb") << data
    file.close
		# greet
	  HardWorker::SendGreetJob.perform_async(provider.id)
  end
  
end
