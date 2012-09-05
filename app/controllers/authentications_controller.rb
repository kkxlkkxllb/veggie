class AuthenticationsController < Devise::OmniauthCallbacksController
  def weibo
    omniauth_process
  end
  
  protected
    def omniauth_process
      omniauth = request.env['omniauth.auth']
      
      if p = Provider.exsit?(omniauth.provider,omniauth.uid)
        sign_in(:user, p.member)
        redirect_to root_path
      else
        session[:omniauth] = omniauth.except("extra")
        
        render :text => omniauth.except("extra")
      end
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
end
