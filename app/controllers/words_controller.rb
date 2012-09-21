# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:only => [:destroy,:create]
  def index
    set_seo_meta(t('words.title'),t('words.keywords'),t('words.describe'))
    @words = Word.all
  end
  
  def create
    @word = FetchWord.new(params[:word]).insert
    html = render_to_string(
            :formats => :html,
            :handlers => :haml,
		        :partial => "word",
		        :locals => {:w => @word}
		        )
		render_json(0,"ok",{:html => html})
  end
  
  def add_tag
    @word = Word.find(params[:id])
    @word.ctag_list = Word.parse_tag(params[:tags]).join(",")
    if @word.save!
      render_json(0,"ok",{:title => @word.hash_tags})
    end
  end
  
  # TO-DO destroy u_word
  def destroy  
    if @word = UWord.find(params[:id])
      @word.destroy
      render_json(0,"ok")
    end
  end
end
