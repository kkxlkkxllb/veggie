class MembersController < ApplicationController
  before_filter :authenticate_member!
  
  def show
    @user = params[:id] ? Member.find(params[:id]) : current_member
    set_seo_meta(@user.name)
    @u_words = current_member.u_words
  end
  
  def edit
    set_seo_meta(t("members.edit",:name => current_member.name))
    @setting = true
  end
end
