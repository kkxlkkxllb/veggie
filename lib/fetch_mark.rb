require "open-uri"
require 'nokogiri'

class FetchMark
  
  def initialize(url)
    frame = Nokogiri::HTML(open(url),nil)
  	if frame
  	  @title = frame.css("title")[0].content
  	  @favicon = frame.css("link[rel='shortcut icon']")[0].attr('href')
  		@url = url
  	end
  end
  
  
end