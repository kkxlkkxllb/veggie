# coding: utf-8
class AuthenticationsController < Devise::OmniauthCallbacksController

  Provider::PROVIDERS.each do |m|
    define_method m do
      omniauth_process
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
  protected
    def omniauth_process
      omniauth = request.env['omniauth.auth']
      provider = Provider.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
      expires_time = omniauth.credentials.expires_at.blank? ? nil : Time.at(omniauth.credentials.expires_at.to_i)
      # 已登录状态下，绑定流程
      if current_member
				# 非正常情况：用户发起绑定一个第三方帐号，但是该provider已存在，并且持有人不是当前member
        if provider
					flash[:error] = t('flash.error.bind',:email => $config[:email])
				# 正常绑定
        else
          Provider.create_from_hash(current_member.id, omniauth, expires_time)
          flash[:success] = t('flash.notice.bind')         
        end
        redirect_to setting_path + "#provider"
			# 非登录状态下，注册/登录
      else
				# 登录
        if provider
          reset_token_secret(provider, omniauth, expires_time)  
          flash[:success] = t('flash.notice.login')
          sign_in_and_redirect(provider.member)
				# 注册
        else
          new_user = Member.generate
          Provider.create_from_hash(new_user.id, omniauth, expires_time)
          sign_in(new_user)
          # 测试课程 载入
          Course.hello.check(new_user)
          flash[:success] = t('flash.notice.register')
          redirect_to setting_path + "#account"
        end
      end
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
    
    def reset_token_secret(provider,omniauth,expires_time)    
        provider.update_attributes(:token => omniauth.credentials.token,
                                   :secret => omniauth.credentials.secret,
                                   :metadata => omniauth.info,
                                   :expired_at => expires_time)
    end
end
