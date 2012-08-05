# -*- coding: utf-8 -*-
require "open-uri"
require 'nokogiri'

class FetchWord
  
  def initialize(word)
    url = DICT_SOURCE[:english]+word
    frame = Nokogiri::HTML(open(url),nil)
    if frame
      @comment = frame.css("#panel_com")[0].content.split("<br>")[0..2].join(" ")
      @word = word
    end
  end
  
  def insert    
    if !@comment.blank?
      Word.create(@word,@comment)
    end    
  end  
  
end