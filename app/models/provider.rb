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
  after_create :init_leafs
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
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
  
  def get_leafs(older = true)
    if older
      id = self.leafs.minimum(:weibo_id)
      return "&max_id=#{id}"
    else
      id = self.leafs.maximum(:weibo_id)
      return "&since_id=#{id}"
    end
  end
  
  def self.build_leaf(older = true,options = {})
    if options[:provider]
      LeafGrow.new(options[:provider]).grow(:older => older)
    else
      Provider.all.each do |p|
        LeafGrow.new(p).grow(:older => older)
      end
    end
  end
  
  private
  def init_leafs
    LeafGrow.new(self).grow
  end

end
