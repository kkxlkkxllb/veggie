# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Veggie::Application.initialize!

$dict_source = {}
$dict_source[:english] = "http://dict.hjenglish.com/w/"
$dict_source[:english_v] = "http://tts.yeshj.com/uk/s/"

$config = {}
$config[:domain] = "17up.org"
$config[:host] = "http://#{$config[:domain]}"
$config[:mobile_host] = "http://m.#{$config[:domain]}"

$config[:oauth]={
  :weibo => ["83541187","70968cae2cbaf5bf060878d5b169691e"]
}