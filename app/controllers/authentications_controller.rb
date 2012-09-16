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
      if provider
        reset_token_secret(provider,omniauth)  
        sign_in(provider.member)
        flash[:success] = t('flash.notice.login')
        redirect_to account_path
      elsif current_member
        Provider.create_from_hash(current_member.id, omniauth)
        flash[:success] = t('flash.notice.bind')
        redirect_to account_path
      else
        new_user = Member.generate
        Provider.create_from_hash(new_user.id, omniauth)
        sign_in(new_user)
        flash[:success] = t('flash.notice.register')
        redirect_to account_path
      end
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
    
    def reset_token_secret(provider,omniauth)    
        provider.update_attributes(:token => omniauth.credentials.token,
                                   :secret => omniauth.credentials.secret)
    end
end
