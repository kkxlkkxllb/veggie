$dict_source = {}
$dict_source[:english] = "http://dict.hjenglish.com/w/"
$dict_source[:english_v] = "http://tts.yeshj.com/uk/s/"

$config = {}
$config[:domain] = "17up.org"
$config[:host] = "http://#{$config[:domain]}"
$config[:mobile_host] = "http://m.#{$config[:domain]}"
$config[:blog_host] = "http://blog.#{$config[:domain]}"

Resque.redis = Redis.connect(:url=>"redis://192.168.0.1:6379/")
Resque.redis.namespace = 'veggie-resque'