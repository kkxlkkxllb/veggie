# coding: utf-8 
module ApplicationHelper
  def time_stamp(datatime)
    if datatime.today?
      "今天"
    else
      datatime.strftime("%m月%d日")
    end
  end
  
  def my_image_tag(url,link)
    link_to image_tag(url,:onError=>"this.src='/assets/icon/omg.png'"),link,:target => "blank"
  end
  
end
