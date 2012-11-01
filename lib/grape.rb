require "open-uri"
# image function
module Grape
  class Base
    def load_service
      YAML.load_file(Rails.root.join("config", "service.yml")).fetch(Rails.env)
    end
    
    def img_save(url,output,success,error)
      begin
        data = open(url){|f|f.read}
		    file = File.open(output,"wb") << data
        file.close
        success.call
      rescue
        error.call
      end
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
          filename = "#{k.to_s}.#{v.split('.')[-1]}"
          error = -> { Leaf.logger.error("ERROR #{v} not found! skip") }
          success = -> { }
          img_save(v,@store_path+filename,success,error)
        end
      end
    end
  
  end
  
  class WordImage < Base
    STORE_FOLDER = "#{Rails.root}/public/system/images/word/"
    
    def initialize(title)
      @title = title
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
			data.inject([]){|a,x| a << x["MediaUrl"] }
    end   
    
    def make
      @images = parse
      path = STORE_FOLDER + @title.parameterize.underscore + ".jpg"
      unless File.exist?(STORE_FOLDER)
        `mkdir -p #{STORE_FOLDER}`
      end
      error = -> { puts "#{@images[0]} catch failed" }
      success = -> { ImageConvert.new(path).draw(20,20,@title)  }
      img_save(@images[0],path,success,error)
    end
  end
  
  class ImageConvert
    def initialize(img_path,opts={})
      @opts = {
        :font_color  => '#eee', 
        :font_size   => 24, 
        :font_file   => "public/font/Tallys/Tallys.ttf", 
        :outfile     => img_path,#Tempfile.new("quote_image").path, 
        :watermark   => "17up.org"  # 水印
      }.update(opts)

      @img=Magick::Image.read(img_path).first
      @img_width = @img.columns
      @img_height = @img.rows
    end
    
    def add_watermark
      gc = Magick::Draw.new 
      gc.pointsize(@opts[:font_size])
      gc.fill(@opts[:font_color])
      gc.stroke('transparent')
      gc.font(@opts[:font_file])
      gc.text(@img_width - 100,@img_height - 20,@opts[:watermark])
      gc.draw(@img)
    end
    
    def draw(x,y,text)
      add_watermark
      gc = Magick::Draw.new 
      gc.pointsize(@opts[:font_size])
      gc.fill(@opts[:font_color])
      gc.stroke('transparent')
      gc.font_weight('bold')
      gc.font("public/font/Lobster/Lobster.ttf")
      gc.text(x,y,text)
      gc.draw(@img)  
      #@img.transparent_color = 'white'
      #@img.transparent('white')
      @img.write(@opts[:outfile])
      return @opts[:outfile]
    end
    
  end
  
end