# == Schema Information
#
# Table name: leafs
#
#  id          :integer          not null, primary key
#  content     :text
#  provider_id :integer
#  image_url   :string(255)
#  time_stamp  :datetime
#  weibo_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video       :string(255)
#

class Leaf < ActiveRecord::Base
  belongs_to :provider
  validates  :time_stamp, :uniqueness => {:scope => :provider_id }
  #before_destroy :clean_image
  #after_create :fetch_image
  GET_IMAGE_REMOTE = true
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
        ext = self.image_url.split('.')[-1]
        IMAGE_URL + "#{self.id}/#{style}.#{ext}"
      else
        nil
      end
    end
  end
  
  def clean_image
    path = IMAGE_PATH + self.id.to_s
    if File.exist?(path)
      `rm -rf #{path}`
      Leaf.logger.info("INFO #{path} has been destroyed!")
    end
  end
  
  def fetch_image
    if !self.image_url.blank?
      FetchImage.new(self).download
    end
  end
  
  def self.logger
    Logger.new(File.join(Rails.root,"log","leaf.log"))
  end
  
  # 下载所有图
  def self.fetch_all_image
    Leaf.where("image_url IS NOT NULL").each do |l|
      FetchImage.new(l).download
      return nil 
    end
  end
end
