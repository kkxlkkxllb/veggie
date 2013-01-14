# coding: utf-8 
module ApplicationHelper
  def time_stamp(datatime)
    if datatime.today?
      "今天"
    else
      datatime.strftime("%m月%d日")
    end
  end
 
  def my_image_tag(url,link,height='')
    img = image_tag("data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==",:'data-src' => url,:style =>"height:#{height}px")
    if link
      link_to img,link,:target => "blank"
    else
      img
    end
  end
  
  def trc(str,len)
    truncate(str,:length => len)
  end

	def file_upload_for(type)
		case type
		when "image"
			accept = 'image/png,image/gif,image/jpeg'
		when "mov"
			accept = "video/*"
		end
		file_field_tag type.to_sym,:accept => accept
	end
  
end
