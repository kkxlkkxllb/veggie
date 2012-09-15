class SessionsController < Devise::SessionsController
  def new
    set_seo_meta(t('door'),t('keywords'),t('describe'))
    super
  end
end