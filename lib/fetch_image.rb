require "open-uri"

class FetchImage
  
  def initialize(leaf)
    @leaf = leaf     
    @image_urls = {:large => leaf.image_url,
                   :medium => leaf.image_url.sub('large','bmiddle'),
                   :thumb => leaf.image_url.sub('large','thumbnail')}
    @store_path = Leaf::IMAGE_PATH+"#{leaf.id}/"
  end
  
  def download
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