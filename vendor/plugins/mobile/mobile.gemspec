$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mobile/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mobile"
  s.version     = Mobile::VERSION
  s.authors     = ["veggie"]
  s.email       = ["kkxlkkxllb@gmail.com"]
  s.homepage    = "m.17up.org"
  s.summary     = "17up mobile"
  s.description = "17up mobile version"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
