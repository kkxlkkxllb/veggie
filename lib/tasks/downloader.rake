namespace :downloader do
  
  desc "start download"
  task :start => :environment do
		url = ENV['URL']
		name = ENV['NAME']
		if url && name
			output = "/home/www/download/" + name
			`wget '#{url}' -O #{output}`
		else
			p "Need params URL & NAME"
		end
  end

end
