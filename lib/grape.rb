require "open-uri"
# image function
module Grape
  class Base
    def load_service
      YAML.load_file(Rails.root.join("config", "service.yml")).fetch(Rails.env)
    end
  end
  
  class LeafImage
  
    def initialize(leaf)
      @leaf = leaf     
      @image_urls = {:large => leaf.image_url,
                     :medium => leaf.image_url.sub('large','bmiddle'),
                     :thumb => leaf.image_url.sub('large','thumbnail')}
      @store_path = Leaf::IMAGE_PATH+"#{leaf.id}/"
    end
  
    def download
      if Dir[@store_path+"*"].empty?
         `rmdir #{@store_path}`
      end
      if File.exist?(@store_path)
        Leaf.logger.warn("WARN #{@store_path} already exsit! stop")
      else
        `mkdir -p #{@store_path}`
        @image_urls.each do |k,v|
          begin
            filename = "#{k.to_s}.#{v.split('.')[-1]}"
    		    data = open(v){|f|f.read}
      		  file = File.open(@store_path+filename,"wb") << data
            file.close
          rescue
            Leaf.logger.error("ERROR #{v} not found! skip")
          end
        end
      end
    end
  
  end
  
  class WordImage < Base
    def initialize(title)
      title = URI.encode(title)
      @cid = load_service["bing"]["client_id"]
      @cpw = load_service["bing"]["client_secret"]
      @base_url = "https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Image?Query='#{title}'&$format=json"
    end

    def parse
			url = URI.parse(@base_url)
	    req = Net::HTTP::Get.new(@base_url)
	    req.basic_auth @cid, @cpw
	    response = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
				http.request(req) 
			end
	    data = JSON.parse(response.body)["d"]["results"]
			@pic_urls = data.inject([]){|a,x| a << x["MediaUrl"] }
    end   
  end
  
  class ImageConvert
    def initialize(quote,img_path,opts={})
      @opts = {
        :font_color  => '#eee', 
        :font_size   => 20, 
        :font_file   => File.join(Rails.root, "public/font/Tallys", "Tallys.ttf"), 
        :outfile     => "public/quote.jpg",#Tempfile.new("quote_image").path, 
        :watermark   => "17up.org"  # 水印
      }.update(opts)
      @quote = quote
      @img_path = img_path
    end
    
    def done
      img_width = Dimensions.width(@img_path)
      img_height = Dimensions.height(@img_path)
      cmd = [
        "convert -size #{img_width}x#{img_height} xc:transparent",
        "-font #{@opts[:font_file]} -pointsize #{@opts[:font_size]}",
        "-gravity SouthEast",
        "-fill \'#{@opts[:font_color]}\' -annotate 0x0+20+#{img_height-20*2} \"#{@opts[:watermark]}\"",
        "\"#{@img_path}\" +swap -composite #{@opts[:outfile]}"
      ].join(" ")
      `#{cmd}`
      return @opts[:outfile]
    end
    
  end
  
end