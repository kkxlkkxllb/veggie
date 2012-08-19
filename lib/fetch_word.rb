# -*- coding: utf-8 -*-
require "open-uri"
require 'nokogiri'

class FetchWord
  
  def initialize(word)
    url = DICT_SOURCE[:english]+word
    frame = Nokogiri::HTML(open(url),nil)
    if frame
      begin
        body = frame.css("#panel_com")
        if body.blank?
          body = frame.css("#panel_comment")
        end
        @comment = body[0].content.split("<br>")[0..2].join(" ")
        
        @word = word
      rescue
        nil
      end
    end
  end
  
  def insert    
    if !@comment.blank?
      Word.create(@word,@comment)
    end    
  end  
  
end