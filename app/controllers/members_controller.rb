class MembersController < ApplicationController
  before_filter :authenticate_member!
  
  def show
    @user = params[:id] ? Member.find(params[:id]) : current_member
    set_seo_meta(@user.name)
    @u_words = @user.u_words
    @p_words = @u_words.select{|w| w.has_image}
    if @user == current_member
      @owner = true
      @t_words = @u_words - @p_words
    end
  end
  
  def edit
    set_seo_meta(t("members.edit",:name => current_member.name))
    @setting = true
  end
end
