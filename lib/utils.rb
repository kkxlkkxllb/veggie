# -*- coding: utf-8 -*-
module Utils
  class Helper
    include ActionView::Helpers
  end
  
  def self.rand_passwd(size=6, opts = {})
    passwd = []
    # 全部使用字母
    if opts[:number] == true
      alpha = (0..9).to_a
    elsif opts[:alpht] == true
      alpha = ('a'..'z').to_a
    else
      alpha = (0..9).to_a+('a'..'z').to_a+('A'..'Z').to_a
    end
    
    size.times{passwd << alpha[rand(alpha.size)]}
    passwd.join
  end
  
  def self.rand_activate_code(size=4)
    self.rand_passwd(size, :number => true)
  end
  
  module Curl
    def self.get(url, data={})
      params = data.nil? ? "" : "?".concat( data.collect{ |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&') )
      
      uri = URI(url+params).to_s
      `curl '#{uri}' 2>/dev/null`
    end
    
    def self.post(url,data={})
      form = data.map{|k,v| "-F #{k}=#{v}"}.join(" ")
      `curl #{form} '#{url}' 2>/dev/null`
    end
  end
  
end
