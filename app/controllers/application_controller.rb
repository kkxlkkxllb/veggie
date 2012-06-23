class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_seo_meta(title,keywords = '',desc = '')
    if title
      @title = "#{title}"
      @title += "&raquo;17UP"
    else
      @title = "17UP"
    end
    @meta_keywords = keywords
    @meta_description = desc
  end
end
