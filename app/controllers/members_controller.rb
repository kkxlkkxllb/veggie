class MembersController < ApplicationController
  before_filter :authenticate_member!,:except => :show
  
  def dashboard
    set_seo_meta(current_member.name)
    @u_words = current_member.u_words
  end
  
  def show
    @user = Member.find(params[:id])
    set_seo_meta(@user.name)
    @p_words =  @user.u_words.select{|w| w.has_image}
  end
  
  def edit
    set_seo_meta(t("members.edit",:name => current_member.name))
    @setting = true
  end
end
