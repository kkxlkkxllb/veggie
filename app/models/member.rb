# == Schema Information
#
# Table name: members
#
#  id                     :integer          primary key
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
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
  attr_accessible :email, :password, :password_confirmation, :remember_me,:role,:uid
  # uid 代替id，由用户自定义，长度限定
  validates :uid, :uniqueness => {:scope => :role },
                  :length => {:in => 2..20 },
                  :format => {:with => /^[A-Za-z0-9_]+$/ }

  has_many :providers,:foreign_key => "user_id",:dependent => :destroy
  has_many :u_words,:dependent => :destroy

  after_destroy :clear_data
  
  EDIT_SIDENAV = %w{profile provider account}
  AVATAR_URL = "/system/images/member/"
  AVATAR_PATH = "#{Rails.root}/public"+AVATAR_URL
  AVATAR_SIZE_LIMIT = 500*1000 #500k
  ## role 用户组别 
  ROLE = %w{a u b e g v}
  # nil 三无用户，被清理对象
  scope :x, where(["role is ?", nil])
  # a 管理员，特权待遇 
  # u 会员
  # ------
  # b 商家*
  # e 作者*
  # g 组织
  # v 名人
  ROLE.each do |r|
    scope r.to_sym,where(["role = ?", r])
  end
  
  def admin?
    self.role == "a"
  end

  def member_path
    role ? "/#{role}/#{uid}" : "#"
  end
  
  def avatar
		File.exist?(AVATAR_PATH + avatar_name) ? (AVATAR_URL + avatar_name) : "icon/avatar.png"
  end

	def avatar_name
		"#{self.id}/#{self.created_at.to_i}.jpg"
	end

  def validate_upload_avatar(file,type)
    type.scan(/(jpeg|png|gif)/).any? and File.size(file) < IMAGE_SIZE_LIMIT
  end
  
  def name
    p = self.providers.first
    p ? p.user_name : $config[:author]
  end
  
  # p : string in [Provider::PROVIDERS]
  def has_provider?(p)
    self.providers.where(:provider => p).first
  end
  
  # To-Do add index to uword db
  def has_u_word(wid)
    UWord.where(:member_id => self.id,:word_id => wid).first
  end
  
  def self.generate(prefix = Utils.rand_passwd(7,:number => true))
    email = prefix + "@" + $config[:domain]
    passwd = Utils.rand_passwd
    user = Member.new(
      :email => email,
      :password => passwd,
      :password_confirmation => passwd)
    if user.save!
      user
    else
      self.generate(prefix + "v")
    end
  end
  
  def as_json
    {
      :uid => uid,
      :name => name,
      :avatar => avatar,
      :u_words_cnt => self.u_words.count
    }
  end

  def save_avatar(file_path)
    `mkdir -p #{AVATAR_PATH + self.id.to_s}`
    data = open(file_path){|f|f.read}
    file = File.open(AVATAR_PATH + avatar_name,"wb") << data
    file.close
  end

  def clear_data
    `rm -rf #{AVATAR_PATH + self.id.to_s}`
  end 
  
end
