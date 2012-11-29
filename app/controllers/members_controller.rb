class MembersController < ApplicationController
  before_filter :authenticate_member!
  
  def show
    @user = params[:id] ? Member.find(params[:id]) : current_member
    set_seo_meta(@user.name)
    @u_words = @user.u_words
    if @user == current_member
      @can_add_tag = true
    end
  end
  
  def edit
    set_seo_meta(t("members.edit",:name => current_member.name))
    @setting = true
  end
end
