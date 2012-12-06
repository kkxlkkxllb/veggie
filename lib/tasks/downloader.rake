# coding: utf-8 
namespace :downloader do
  
  desc "start download"
  task :start => :environment do
		url = ENV['URL']
		name = ENV['NAME']
		if url && name
			output = "/home/www/download/" + name
			`wget #{url} -O #{output}`
		end
  end

end
