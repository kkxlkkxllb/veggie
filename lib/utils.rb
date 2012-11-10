# -*- coding: utf-8 -*-
module Utils
  class Helper
    include ActionView::Helpers
  end
  
  def self.parse_ip(ip)
    api_url = "http://ip.taobao.com/service/getIpInfo.php?ip="
    resp = Net::HTTP.get_response(URI.parse(api_url+ip)).body
		data = JSON.parse(resp)
		if data["code"] == 0
			return data["data"]["country"] + data["data"]["region"] + data["data"]["city"] + data["data"]["isp"]
		end
  end
  
  # forecast
  def self.check_weather(city="杭州")
    api_url = "http://sou.qq.com/online/get_weather.php?callback=Weather&city="
    request_url = URI.encode(api_url+city)
    resp = Net::HTTP.get_response(URI.parse(request_url)).body
		data = JSON.parse(resp.scan(/Weather\((\S+)\)/).flatten[0])
		if data["real"]
		  data["future"]["name"] + data["future"]["wea_0"] + data["real"]["temperature"] 
	  end
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
  
  module Cloud
    class Base
      def initialize(login={})
      	login = {
  				:name => "kkxlkkxllb@gmail.com",
  				:passwd => ""
  			}.update(login)
  			@session = GoogleDrive.login(login[:name], login[:passwd])
  		end

  		def list
  			@session.files.inject([]){|a,x| a << x.title}
  		end

  		def upload(file_path,file_name)
  			@session.upload_from_file(file_path, file_name, :convert => false)
  		end

  		def download(file_name,save_path)
  			file = @session.file_by_title(file_name)
  			if file
  				file.download_to_file(save_path)
  			end
  		end
  		
    end
    
    class Backup < Base
      def word_image
        folder = "public/system/images/word"
      end
      
    end
    
  end 
  
end
