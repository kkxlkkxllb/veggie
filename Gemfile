#source 'https://rubygems.org'
source 'http://ruby.taobao.org'

gem 'rails', '3.2.6'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :require => 'v8'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server


# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem "debugger"

gem 'acts-as-taggable-on'
gem 'paperclip'
gem 'nokogiri', '~>1.5.0'
gem 'kaminari'
gem "remotipart", "~> 1.0"
gem 'rails_admin'
gem "omniauth-weibo", :git => 'git://github.com/ballantyne/omniauth-weibo.git'
gem 'haml'
gem 'rails_autolink'

group :production do
  gem 'mysql2'
  gem 'unicorn'
end

group :development, :test do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
	gem 'haml-rails'
	gem 'sqlite3'
	gem 'puma'
	gem 'rspec-rails', '~> 2.10.0'
	gem 'factory_girl_rails'
end

gem "devise"
gem 'redis'
gem 'whenever', :require => false
gem 'weibo2'