# coding: utf-8 
module Onion
  # 查单词
  class FetchWord  
    def initialize(word)
      url = $dict_source[:english]+word
      frame = Nokogiri::HTML(open(url),nil)
      if frame
        begin
          body = frame.css("#panel_com")
          if body.blank?
            body = frame.css("#panel_comment")
          end
          @comment = body[0].content.split("<br>")[0..2].join(" ")
        
          @word = word
        rescue
          nil
        end
      end
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
        @author_url = @base_url + "/author/show/" + spell_author(opt[:author_id])
      elsif opt[:author]
        @url = @base_url + "/author/quotes/" + opt[:author]
        @author_url = @base_url + "/author/show/" + opt[:author]
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
          new_author_url = @author_url ? @author_url : @base_url + x.css("a").attr("href").value
          x.css("a")[0]["href"] =  new_author_url    
          x.css("a")[0]["target"] = "blank"    
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