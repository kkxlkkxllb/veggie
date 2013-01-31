class MembersController < ApplicationController
  before_filter :authenticate_member!,:except => :show
  before_filter :require_member!,:only => :update
  # 个人学习系统界面
  def dashboard
    set_seo_meta(current_member.name)
    if params[:course]
      begin
        @course = Course.open.find(params[:course])
        @course.check(current_member)
      rescue
        nil
      end
    else
      @course = current_member.current_course
    end
    @u_words = @course ? @course.words : []
  end
  
  # :role/:uid
  # 根据不同用户类别，显示略有差异的个人秀，前提是该用户已登记uid
  # 用户默认类别: u 见 Member::ROLE
  # 名片展示：姓名／头像／关联的身份
  # 个人秀可被操作的动作：7 js转发weibo
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
  
  # 会员入口
  # 付费成功后回调
  def apply_uid
    current_member.update_attribute(:role,"u")
    HardWorker::SendGreetJob.perform_async(current_member.id)
  end

  # set uid
  def update  
    if params[:uid].blank?
      flash[:error] = t('flash.error.blank')
    else
      if @user = Member.u.find_by_uid(params[:uid])
        flash[:error] = t('flash.error.uid')
      else
        data = {
          :uid => params[:uid],
          :email => params[:uid] + "@" + $config[:domain]
        }
        current_member.update_attributes(data)
        flash[:notice] = t('flash.notice.uid')
      end
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

  private
  def require_member!
    unless current_member.is_member?
      render :status => :unauthorized
    end
  end

end
