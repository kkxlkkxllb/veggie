# == Schema Information
#
# Table name: leafs
#
#  id          :integer          not null, primary key
#  content     :text
#  provider_id :integer
#  image_url   :string(255)
#  time_stamp  :datetime
#  weibo_id    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video       :string(255)
#  width       :integer
#  height      :integer
#

class Leaf < ActiveRecord::Base
  belongs_to :provider
  validates  :time_stamp, :uniqueness => {:scope => :provider_id }
  before_destroy :clean_image
  after_create :fetch_image
  
  IMAGE_URL = "/system/images/leaf/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL
  
  def image(style = :large,remote = (Rails.env != "production"))
    if image_url
      if remote
        case style
        when :thumb
          self.image_url.sub('large','thumbnail')
        when :medium
          self.image_url.sub('large','bmiddle')
        when :large
          self.image_url
        end
      else# 本地图片
  			case style
  			when :large
        	self.image_url
  			else      	
        	IMAGE_URL + local_image_name(style)
  			end
      end
    end
  end

  def local_image_name(style)
    ext = image_url.split('.')[-1]
    return "#{self.id}/#{style}.#{ext}"
  end
  
  def clean_image
    path = IMAGE_PATH + self.id.to_s
    if Rails.env == "production" and File.exist?(path)
      `rm -rf #{path}`
      Leaf.logger.info("INFO #{path} has been destroyed!")
    end
  end
  
  def fetch_image
    if Rails.env == "production" and !self.image_url.blank?
      Grape::LeafImage.new(self).download
    end
  end
  
  def self.logger
    Logger.new(File.join(Rails.root,"log","leaf.log"))
  end
  
  # 下载所有图
  def self.fetch_all_image(opts={})
    Leaf.where("image_url IS NOT NULL").each do |l|
      if opts[:geo]
        w,h = Grape::ImageConvert.geo(IMAGE_PATH + l.local_image_name(:medium))
        l.update_attributes(:width => w,:height => h)
      else
        Grape::LeafImage.new(l).download
      end
    end
  end

  def as_json
    {
      :id => id,
      :url => provider.url,
      :avatar => provider.avatar,
      :pid => provider.id,
      :name => provider.user_name,
      :time_stamp => time_stamp,
      :content => content,
      :img => image(:medium),
      :img_large => image(:large),
      :height => real_height(194)
    }
  end
  
  private
  def real_height(real_width)
    if height
      (height.to_f/width.to_f)*real_width.to_i
    end
  end
end
