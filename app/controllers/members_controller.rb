class MembersController < ApplicationController
  before_filter :authenticate_member!,:except => :show
  
  def dashboard
    set_seo_meta(current_member.name)
    @u_words = current_member.u_words
  end
  
  # :role/:uid
  def show
    role_ok = Member::ROLE.include?(params[:role])  
    if role_ok and @user = Member.send(params[:role]).find_by_uid(params[:uid])
      set_seo_meta(@user.name)
      @p_words =  @user.u_words.select{|w| w.has_image}      
    else
      redirect_to "/not_found"
    end
  end
  
  def edit
    set_seo_meta(t("members.edit",:name => current_member.name))
    @setting = true
  end

  # update uid then set role to u
  def update
    
  end


end
