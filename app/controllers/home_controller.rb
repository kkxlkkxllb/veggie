# coding: utf-8
class HomeController < ApplicationController
  before_filter :redirect_home,:only => :index
  caches_page :index
  
  def index
    set_seo_meta(nil,t('keywords'),t('describe'))
    @is_root = true
  end
  
  def hot
    set_seo_meta(t("hot.title"),t('hot.keywords'),t('hot.describe'))
    @users = Provider.where("user_id is null")
  end
  
  def info
    set_seo_meta("简介",t('keywords'),t('describe'))
    @request = request.remote_ip
    @info = TaobaoIpParser.new(@request).parse
  end
  
  private
  
  def redirect_home
    agent = request.user_agent.downcase
    if current_member
      redirect_to account_path
    elsif agent.include?("iphone") or agent.include?("android")
      redirect_to $config[:mobile_host]
    end
  end
end
