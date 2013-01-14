class BusinessController < ApplicationController
  def index
    set_seo_meta(t("business.title"),t('business.keywords'),t('business.describe'))
    @quotes = Rails.cache.fetch("quotes") do
      Onion::FetchQuote.new().done
    end
  end
end
