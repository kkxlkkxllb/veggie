class SessionsController < Devise::SessionsController
  def new
    set_seo_meta(t('door'),t('keywords'),t('describe'))
    @need_footer = true
    super
  end
end