# coding: utf-8
class HomeController < ApplicationController
  before_filter :redirect_mobile,:only => :index
  def index
    set_seo_meta(nil,"17up,NGO,梦想,实践,未来,教育","一起暸望新世界的风景，创新的育人方式")
    @is_root = true
  end
  
  def hot
    set_seo_meta("名人","17up,NGO,梦想,实践,未来，教育","一起暸望新世界的风景，创新的育人方式")
    @users = Provider.all
  end
  
  def info
    set_seo_meta("简介","17up,NGO,梦想,实践,未来，教育","一起暸望新世界的风景，创新的育人方式")
    @request = request.remote_ip
    @info = TaobaoIpParser.new(@request).parse
  end
  
  private
  
  def redirect_mobile
    if request.user_agent.downcase.include?("iphone")
      redirect_to $config[:mobile_host]
    end
  end
end
