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
#  expired_at :datetime
#

class Provider < ActiveRecord::Base
  has_many :leafs, :dependent => :destroy
  serialize :metadata, Hash
  validates :provider, :presence => true
  validates :uid, :presence => true, :uniqueness => {:scope => :provider}
  belongs_to :member,:foreign_key => "user_id"
  after_create :send_greet
  
  PROVIDERS = %w{twitter weibo github tumblr instagram youtube}
  
  def avatar(style = :mudium)
    image = metadata[:image] ? metadata[:image] : metadata[:avatar]
    case style
    when :mudium
      image
    when :large
      case provider_type
      when "weibo"
        image.gsub("/50/","/180/")
      when "twitter"
        image.gsub("_normal","")
      when "tumblr"
        image.gsub("_64","_512")
      else
        image
      end
    end
  end
  
  def provider_type
    self.provider.sub("_#{$config[:name]}","")
  end
  
  def user_name
    name = self.metadata[:name]
    return name ? name : self.metadata[:nickname]
  end
  
  # @twitter @weibo
  def at_name
    self.metadata[:nickname]
  end
  
  def url
    url = self.metadata[:weibo_url]
    return url ? url : self.metadata[:url]
  end
  
  def self.create_from_hash(user_id, omniauth, expires_time)
    self.create!(
      user_id:      user_id,
      provider:     omniauth.provider,
      uid:          omniauth.uid,
      token: omniauth.credentials.token,
      secret: omniauth.credentials.secret,
      metadata: omniauth.info,
      expired_at: expires_time
    )
  end
  
  def send_greet
    if self.member 
      if self.member.providers.length > 1
        # 绑定
        HardWorker::SendGreetJob.perform_async(self.id,{:bind => true})
      else
        # 注册 save avatar from provider
        self.member.save_avatar(avatar(:large))
      end     
    end
  end

  # leaf
  def get_leafs(older)
    if older
      id = self.leafs.order("time_stamp ASC").first.weibo_id
      return "&max_id=#{id}"
    else
      id = self.leafs.order("time_stamp DESC").first.weibo_id
      return "&since_id=#{id}"
    end
  end

  # :older => true/false
  def grow_leaf(opts = {})
    eval("Wheat::#{provider_type.capitalize}").new(self).grow(opts)
  end

end
