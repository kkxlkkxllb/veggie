# coding: utf-8 
module Onion
  # 查单词
  class FetchWord  
    def initialize(word)
      url = $dict_source[:english]+word
      page = Mechanize.new.get(url)
      target = page.parser.xpath("//div[@class='simple_content']")
      @word = word
      @comment = target.text.gsub("\r\n","").strip      
    end
  
    def insert    
      if !@comment.blank?
        Word.create(:title => @word,:content => @comment)
      end    
    end   
  end
  
  class FetchQuote
    # tag : inspirational
    # author : 947.William_Shakespeare
    # author_id : 947
    def initialize(opt={})
      @base_url = "http://www.goodreads.com"
      if opt[:author_id]
        @url = @base_url + "/author/quotes/" + spell_author(opt[:author_id])
      elsif opt[:author]
        @url = @base_url + "/author/quotes/" + opt[:author]
      elsif opt[:tag]
        @url = @base_url + "/quotes/tag/" + opt[:tag]
      else
        @url = @base_url + "/quotes"
      end
    end
    
    def done
      frame = Nokogiri::HTML(open(@url),nil)
      if frame
        @quotes = frame.css(".quoteText").inject([]) do |a,x|  
          x.css("a").each do |link|
            link["href"] = @base_url + link["href"]
            link["target"] = "blank" 
          end  
          a << x.to_html
        end
      end
    end
    
    private
    def spell_author(id)
      name = YAML.load_file(Rails.root.join("lib/cherry", "goodreads.yml")).fetch("author")[id]
      "#{id}.#{name}"
    end
  end
end