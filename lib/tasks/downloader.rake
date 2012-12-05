# coding: utf-8 
namespace :downloader do
  
  desc "start download"
  task :start => :environment do
		url = ENV['URL']
		name = ENV['NAME']
		if url && name
      folder = "/home/www/" + name
      data = open(url){|f|f.read}
	    file = File.open(folder,"wb") << data
	    size = File.size(file)
	    p "mission complete #{size}"
    else
      p "need url and name"
    end
  end

end
