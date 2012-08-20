require 'net/http'
require 'json'
class TaobaoIpParser

	API_URL = "http://ip.taobao.com/service/getIpInfo.php?ip="

	def initialize(ip)
    @ip = ip
  end

	def parse
		resp = Net::HTTP.get_response(URI.parse(API_URL+@ip)).body
		data = JSON.parse(resp)
		if data["code"] == 0
			return data["data"]["country"] + data["data"]["region"] + data["data"]["city"] + data["data"]["isp"]
		end
	end

end