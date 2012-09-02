Rails.application.config.middleware.use OmniAuth::Builder do
  $config[:oauth].each do |key, value|
    provider key, *value
  end
end