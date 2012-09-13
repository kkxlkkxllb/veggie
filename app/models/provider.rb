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

class Provider < ActiveRecord::Base
  has_many :leafs, :dependent => :destroy
  serialize :metadata, Hash
  validates :provider, :presence => true
  validates :uid, :presence => true, :uniqueness => {:scope => :provider }
  belongs_to :member,:foreign_key => "user_id"
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  PROVIDERS = %w{twitter weibo}
  
  def avatar(style = :mudium )
    case style
    when :mudium
      self.metadata[:image]
    when :large
      case self.provider
      when "weibo"
        self.metadata[:image].gsub("/50/","/180/")
      when "twitter"
        self.metadata[:image].gsub("_normal","")
      end
    end
  end
  
  def user_name
    self.metadata[:name]
  end
  
  def weibo
    self.metadata[:weibo_url]
  end
  
  def get_leafs(older)
    if older
      id = self.leafs.minimum(:weibo_id)
      return "&max_id=#{id}"
    else
      id = self.leafs.maximum(:weibo_id)
      return "&since_id=#{id}"
    end
  end
  
  def self.build_leaf(older = false,options = {})
    if options[:provider]
      LeafGrow.new(options[:provider]).grow(:older => older)
    else
      Provider.where("user_id is null").each do |p|
        LeafGrow.new(p).grow(:older => older)
      end
    end
  end
  
  def self.create_from_hash(user_id, omniauth)
    self.create!(
      user_id:      user_id,
      provider:     omniauth.provider,
      uid:          omniauth.uid,
      token: omniauth.credentials.token,
      metadata: omniauth.info
    )
  end

end
