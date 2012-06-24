# -*- coding: utf-8 -*-
require "open-uri"
require 'nokogiri'

class FetchWord
  
  def initialize(word)
    url = "http://dict.hjenglish.com/w/"+word
    frame = Nokogiri::HTML(open(url),nil)
    if frame
      @comment = frame.css("#panel_comment")[0].content.split("\r\n")[0..2].join(" ")
      @word = word
    end
  end
  
  def insert    
    if !@comment.blank?
      vs = VoteSubject.create(:title => @word)
      vf = vs.vote_fields.create(:content => @comment)
      vs.key_id = vf.id
      vs.subject_list << "英语词汇"
      vs.save!
    else
      return false
    end    
  end
  
  
end