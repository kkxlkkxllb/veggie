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
#

class Leaf < ActiveRecord::Base
  belongs_to :provider
  validates  :time_stamp, :uniqueness => {:scope => :provider_id }
  before_destroy :clean_image
  after_create :fetch_image
  
  GET_IMAGE_REMOTE = Rails.env == "production" ? false : true
  IMAGE_URL = "/system/images/leaf/"
  IMAGE_PATH = "#{Rails.root}/public"+IMAGE_URL
  
  def image(style = :large)
    if GET_IMAGE_REMOTE
      case style
      when :thumb
        self.image_url.sub('large','thumbnail')
      when :medium
        self.image_url.sub('large','bmiddle')
      when :large
        self.image_url
      end
    else# 本地图片
      if self.image_url
				case style
				when :large
        	self.image_url
				else
        	ext = self.image_url.split('.')[-1]
        	IMAGE_URL + "#{self.id}/#{style}.#{ext}"
				end
      end
    end
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
  def self.fetch_all_image
    Leaf.where("image_url IS NOT NULL").each do |l|
      Grape::LeafImage.new(l).download
    end
  end
end
