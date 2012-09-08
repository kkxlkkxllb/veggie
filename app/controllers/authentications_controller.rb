class AuthenticationsController < Devise::OmniauthCallbacksController
  def weibo
    omniauth_process
  end
  
  protected
    def omniauth_process
      omniauth = request.env['omniauth.auth']
      provider = Provider.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
      if provider
        sign_in(:member, provider.member)
        flash[:notice] = "Welcome back!"
        redirect_to root_path
      else
        Provider.create_from_hash(nil, omniauth)
        flash[:notice] = "Thank you for your request! #{omniauth.info}"
        redirect_to root_path
      end
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
end
