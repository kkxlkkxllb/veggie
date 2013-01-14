class ErrorsController < ApplicationController
  
  def error_404
    set_seo_meta(t('errors.not_found'),t('keywords'),t('describe'))
  end

  def error_500
    set_seo_meta(t('errors.crash'),t('keywords'),t('describe'))
  end
  
end
