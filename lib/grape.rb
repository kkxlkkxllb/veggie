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
          success = -> {        
            w,h = ImageConvert.geo(@store_path+filename)
            @leaf.update_attributes(:width => w,:height => h)
          }
          img_save(v,@store_path+filename,success){ Leaf.logger.error("ERROR #{v} not found! skip") }
        end
      end
    end
  
  end
  
  class WordImage < Base
    
    def initialize(title)
      @title = title
      @dir = Word::IMAGE_PATH + title.parameterize.underscore + "/"    
    end

    def set_name_by_dir(dir,title,w_dir=dir)
      unless File.exist?(dir)
        `mkdir -p #{dir}`
      end
      w = w_dir + "w.png"
      unless File.exist?(w)
        opts = {
          :text => title,
          :type => 2,
          :word_path => w
        }
        ImageConvert.draw_word(opts)
      end
      return w,dir + "#{$config[:name]}.jpg"
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
      ImageConvert.new(@image,:outfile => @new_image).draw(@w)
    end
  end
  
  class UWordImage < WordImage
    # uw: u_word obj
    def initialize(uw)
      @u_word = uw
      @title = uw.title
      @dir = UWord::IMAGE_PATH + "#{uw.id}/"
    end

    def make(url)
      @w,@new_image = set_name_by_dir(@dir,@title,@u_word.word.image_path(:w => true))
      begin
        h = ImageConvert.new(url,:outfile => @new_image).draw(@w)
        @u_word.update_attributes(:width => UWord::IMAGE_WIDTH,:height => h)
        return 0
      rescue
        return -1
      end
    end
  end
  
  class ImageConvert
    def initialize(img_path,opts={})
      @opts = {
        :outfile => img_path,#Tempfile.new("quote_image").path, 
        :size => UWord::IMAGE_WIDTH
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
        :text => $config[:name],
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

    def self.geo(src)
      img = MiniMagick::Image.open(src)
      return img["width"],img["height"]
    end
    
		# 合成单张
    def draw(word_path)
      @img.resize @opts[:size].to_s
      result = @img.composite(MiniMagick::Image.open(word_path)) do |c|
        c.gravity "center"
      end
      result.write(@opts[:outfile])
      `chmod 777 #{@opts[:outfile]}`
      return @img["height"]
    end

		# 多张合成gif
		def make_gif(path)
			
		end
    
  end
  
end
