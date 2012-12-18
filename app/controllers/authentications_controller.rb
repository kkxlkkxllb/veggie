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
      if provider
        reset_token_secret(provider, omniauth, expires_time)  
        sign_in(provider.member)
        flash[:success] = t('flash.notice.login')
        redirect_to account_path
      elsif current_member
        Provider.create_from_hash(current_member.id, omniauth, expires_time)
        flash[:success] = t('flash.notice.bind')
        redirect_to setting_path + "#provider"
      else
        new_user = Member.generate
        Provider.create_from_hash(new_user.id, omniauth, expires_time)
        sign_in(new_user)
        flash[:success] = t('flash.notice.register')
        redirect_to setting_path + "#account"
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
