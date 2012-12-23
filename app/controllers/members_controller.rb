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
      @p_words =  @user.u_words.show.map(&:as_json)
      @no_header = true      
    else
      redirect_to "/not_found"
    end
  end
  
  def edit
    set_seo_meta(t("members.edit",:name => current_member.name))
    @provider_num = current_member.providers.length
  end

  # just after register
  def update  
    if @user = Member.u.find_by_uid(params[:uid])
      flash[:error] = t('flash.error.uid')
    else
      data = {
        :role => "u",
        :uid => params[:uid],
        :email => params[:uid] + "@" + $config[:domain]
      }
      current_member.update_attributes(data)
      flash[:notice] = t('flash.notice.uid')
    end
    redirect_to setting_path + "#account"
  end

  # response with js.haml
  def upload_avatar
    file = params[:image].tempfile.path 
    type = params[:image].content_type 
    if current_member.validate_upload_avatar(file,type)
      current_member.save_avatar(file)
      @avatar = current_member.avatar + "?#{Time.now.to_i}"
    end
  end


end
