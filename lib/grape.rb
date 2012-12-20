# image function
module Grape
  class Base
    def load_service
      YAML.load_file(Rails.root.join("config", "service.yml")).fetch(Rails.env)
    end
    
    def img_save(url,output,success = -> { },&error)
      begin
        data = open(url){|f|f.read}
		    file = File.open(output,"wb") << data
        file.close
        success.call
				return 0
      rescue
				if block_given?
        	error.call
				else
					p "#{url} save fail!"
				end
				return -1
      end
    end
  end
  
  class LeafImage < Base
  
    def initialize(leaf)
      @leaf = leaf     
      @image_urls = {:medium => leaf.image(:medium,true),:thumb => leaf.image(:thumb,true)}
      @store_path = Leaf::IMAGE_PATH+"#{leaf.id}/"
    end
  
    def download
      if File.exist?(@store_path) and !Dir[@store_path+"*"].empty?
        Leaf.logger.warn("WARN #{@store_path} already exsit! stop")
      else
        `mkdir -p #{@store_path}`
        @image_urls.each do |k,v|
          filename = "#{k.to_s}.#{v.split('.')[-1]}"
          img_save(v,@store_path+filename){ Leaf.logger.error("ERROR #{v} not found! skip") }
        end
      end
    end
  
  end
  
  class WordImage < Base
    
    def initialize(title)
      @title = title
      @dir = Word::IMAGE_PATH + title.parameterize.underscore + "/"      
    end

    def set_name_by_dir(dir,title)
      unless File.exist?(dir)
        `mkdir -p #{dir}`
      end
      w = dir + "w.png"
      unless File.exist?(w)
        opts = {
          :text => title,
          :type => 2,
          :word_path => w
        }
        ImageConvert.draw_word(opts)
      end
      return w,dir + "17up.jpg"#,dir + "original.jpg"
    end

    def parse(info="")
      title = URI.encode("#{@title} #{info}")
      @cid = load_service["bing"]["client_id"]
      @cpw = load_service["bing"]["client_secret"]
      @base_url = "https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Image?Query='#{title}'&$format=json"
			url = URI.parse(@base_url)
	    req = Net::HTTP::Get.new(@base_url)
	    req.basic_auth @cid, @cpw
	    response = Net::HTTP.start(url.host, url.port,:use_ssl => url.scheme == 'https') do |http|
				http.request(req) 
			end
	    data = JSON.parse(response.body)["d"]["results"]
			data.inject([]){|a,x| a << x["MediaUrl"] }
    end   
    
    def make(url=nil)
      @image = url ? url : parse[0]
      @w,@new_image = set_name_by_dir(@dir,@title)
      #success = -> {        
      #  ImageConvert.new(@original,:outfile => @new_image).draw(@w)  
      #}
      #img_save(@image,@original,success)
      begin
        ImageConvert.new(@image,:outfile => @new_image).draw(@w)
        return 0
      rescue
        return -1
      end
    end
  end
  
  class UWordImage < WordImage
    # uw: u_word obj
    def initialize(uw)
      @title = uw.title
      @dir = UWord::IMAGE_PATH + "#{uw.id}/"
    end
  end
  
  class ImageConvert
    def initialize(img_path,opts={})
      @opts = {
        :outfile => img_path,#Tempfile.new("quote_image").path, 
        :size => "280"
      }.update(opts)
      @img = MiniMagick::Image.open(img_path)
    end
    
    # 水印，暂时不用
    def add_watermark(img)
      unless File.exist?("public/water_mark.png")
        opts = {
          :font => "public/font/Tallys/Tallys.ttf",
          :word_path => "public/water_mark.png"
        }
        ImageConvert.draw_word(opts)
      end
      return img.composite(MiniMagick::Image.open("public/water_mark.png")) do |c|
        c.gravity "NorthWest"
      end
    end
    
    def self.draw_word(opts = {})
      opts = {
        :text => "17up",
        :font_size => 36,
        :type => 1,
        :word_path => "public/w.png",
        :font => "public/font/Lobster/Lobster.ttf"
      }.update(opts)
      case opts[:type]
      when 1
      `montage -background none -fill white -font '#{opts[:font]}' \
                 -pointsize #{opts[:font_size]} label:'#{opts[:text]}' +set label \
                 -shadow  xc:transparent -geometry +5+5 \
                 #{opts[:word_path]}`
      when 2
        `convert -size 280x50 xc:transparent -font '#{opts[:font]}' -pointsize #{opts[:font_size]} \
                   -fill black        -annotate +12+32 '#{opts[:text]}' \
                   -fill white       -annotate +13+33 '#{opts[:text]}' \
                   -fill transparent  -annotate +12.5+32.5 '#{opts[:text]}' \
                  -trim #{opts[:word_path]}`
                   
      end
    end

    def self.get_height(src,real_width)
      img = MiniMagick::Image.open(src)
      (img["height"].to_f/img["width"].to_f)*real_width.to_i
    end
    
		# 合成单张
    def draw(word_path)
      @img.resize @opts[:size]
      result = @img.composite(MiniMagick::Image.open(word_path)) do |c|
        c.gravity "center"
      end
      result.write(@opts[:outfile])
      `chmod 777 #{@opts[:outfile]}`
      return @opts[:outfile]
    end

		# 多张合成gif
		def make_gif(path)
			
		end
    
  end
  
end
