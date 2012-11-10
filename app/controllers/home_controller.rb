# coding: utf-8
class HomeController < ApplicationController
  caches_page :index,:quote
  
  def door
    agent = request.user_agent.downcase
    if current_member
      redirect_to account_path
    elsif agent.include?("iphone") or agent.include?("android")
      redirect_to $config[:mobile_host]
    else
      redirect_to welcome_path
    end
  end
  
  def index
    set_seo_meta(nil,t('keywords'),t('describe'))
    @is_root = true
  end
  
  def square
    set_seo_meta(t("square.title"),t('square.keywords'),t('square.describe'))
    @users = Provider.where("user_id is null")
    @fls = YAML.load_file(Rails.root.join("lib/cherry", "setting.yml")).fetch("friend_link")["course"]
  end
  
  def info
    set_seo_meta("简介",t('keywords'),t('describe'))
    @request = request.remote_ip
    @info = Utils.parse_ip(@request)
  end
  
  def quote
    set_seo_meta(t("quote.title"),t('quote.keywords'),t('quote.describe'))
    @quotes = Onion::FetchQuote.new().done
  end
  
end
