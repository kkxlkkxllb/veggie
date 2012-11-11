class Love::LhomeController < ApplicationController
  layout 'love/application'
  def index
    set_seo_meta(t('love.title'),t('love.keywords'),t('love.describe'))
  end
end
