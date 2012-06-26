# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Veggie::Application.initialize!

DICT_SOURCE = {}
DICT_SOURCE[:english] = "http://dict.hjenglish.com/w/"
DICT_SOURCE[:english_v] = "http://tts.yeshj.com/uk/s/"