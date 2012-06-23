Rails.application.config.middleware.use OmniAuth::Builder do
  provider :weibo, '2419359407','e3da528b450aae9e7a0ed2c6cfd2155d'
end