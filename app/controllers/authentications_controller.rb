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
        sign_in(:member, provider.member)
        flash[:notice] = t('flash.notice.login')
        redirect_to words_path
      elsif current_member
        Provider.create_from_hash(current_member.id, omniauth)
        flash[:notice] = t('flash.notice.bind')
        redirect_to root_path
      else
        new_user = Member.generate
        Provider.create_from_hash(new_user.id, omniauth)
        sign_in(:member, new_user)
        flash[:notice] = t('flash.notice.register')
        redirect_to words_path
      end
    end

    def after_omniauth_failure_path_for(scope)
      root_path
    end
end
