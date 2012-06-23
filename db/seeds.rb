# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Member.create(:email => "veggie@17up.org",
              :password => "rccrcc",:password_confirmation => "rccrcc")
providers = %w{
        twitter,JLin7
        weibo,1013327935
        weibo,1194329420
        weibo,2297451200
        weibo,1640093151
        twitter,wlixiong
        twitter,yanghengjun
        twitter,pearlher
        twitter,He_Art_Me
        weibo,2357046451
        weibo,1613965273
        weibo,2540133610
        weibo,2702714643
      }   
providers.each do |p|  
  provider = p.split(",")[0]
  uid = p.split(",")[1]            
  Provider.create(:provider => provider,:uid => uid)
end