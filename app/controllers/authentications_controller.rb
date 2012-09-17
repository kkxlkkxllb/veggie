# coding: utf-8
class AuthenticationsController < Devise::OmniauthCallbacksController
  def weibo
    omniauth_process
  end
  
  def twitter
    omniauth_process
  end
  
  protected
    def omniauth_process
      omniauth = request.env['omniauth.auth']
      provider = Provider.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
      expires_time = omniauth.credentials.expires_at.blank? ? nil : Time.at(omniauth.credentials.expires_at.to_i)
      if provider
        reset_token_secret(provider, omniauth, expires_time)  
        sign_in(provider.member)
        flash[:success] = t('flash.notice.login')
        redirect_to account_path
      elsif current_member
        Provider.create_from_hash(current_member.id, omniauth, expires_time)
        flash[:success] = t('flash.notice.bind')
        redirect_to account_path
      else
        new_user = Member.generate
        Provider.create_from_hash(new_user.id, omniauth, expires_time)
        sign_in(new_user)
        flash[:success] = t('flash.notice.register')
        redirect_to account_path
      end
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
    
    def reset_token_secret(provider,omniauth,expires_time)    
        provider.update_attributes(:token => omniauth.credentials.token,
                                   :secret => omniauth.credentials.secret,
                                   :expired_at => expires_time)
    end
end
