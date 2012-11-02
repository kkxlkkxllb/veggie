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
  
  class LeafImage < Base
  
    def initialize(leaf)
      @leaf = leaf     
      @image_urls = {:large => leaf.image_url,
                     :medium => leaf.image_url.sub('large','bmiddle'),
                     :thumb => leaf.image_url.sub('large','thumbnail')}
      @store_path = Leaf::IMAGE_PATH+"#{leaf.id}/"
    end
  
    def download
      if File.exist?(@store_path) and !Dir[@store_path+"*"].empty?
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
      folder = STORE_FOLDER + @title.parameterize.underscore + "/"
      file = "#{folder}orignal.jpg"
      unless File.exist?(folder)
        `mkdir -p #{folder}`
      end
      error = -> { puts "#{@images[0]} catch failed" }
      success = -> { ImageConvert.new(file,:outfile => "#{folder}17up.jpg").draw(20,30,@title)  }
      img_save(@images[0],file,success,error)
    end
  end
  
  class ImageConvert
    def initialize(img_path,opts={})
      @opts = {
        :font_color  => '#eee', 
        :font_size   => '24', 
        :font_file   => "public/font/Tallys/Tallys.ttf", 
        :outfile     => img_path,#Tempfile.new("quote_image").path, 
        :watermark   => "17up.org",  # 水印
        :size => "280"
      }.update(opts)

      @img = MiniMagick::Image.open(img_path)
      @img_width = @img[:width]
      @img_height = @img[:height]
    end
    
    def add_watermark
      @img.combine_options do |gc|
        gc.pointsize(@opts[:font_size])
        gc.fill(@opts[:font_color])
        gc.stroke('transparent')
        gc.font(@opts[:font_file])
        gc.draw("text #{@img_width - 80},#{@img_height - 10} '#{@opts[:watermark]}'")
      end
    end
    
    def draw(x,y,text)
      @img.resize @opts[:size]
      add_watermark
      @img.combine_options do |gc|
        gc.pointsize(@opts[:font_size])
        gc.fill(@opts[:font_color])
        gc.stroke('transparent')
        gc.weight('bold')
        gc.font("public/font/Lobster/Lobster.ttf")
        gc.draw("text #{x},#{y} '#{text}'")
        #@img.transparent_color = 'white'
        #@img.transparent('white')
      end     
      @img.write(@opts[:outfile])
      return @opts[:outfile]
    end
    
  end
  
end