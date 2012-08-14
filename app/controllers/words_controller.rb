# coding: utf-8
class WordsController < ApplicationController
  def index
    set_seo_meta("生词本")
    @words = Word.all
  end
  
  def create
    @word = FetchWord.new(params[:word]).insert
  end
  
  def search
    input = params[:word]
  end
  
  def destroy
    @word = Word.find(params[:title])
    if @word
      @word.del
      status = 0
    else
      status = -1
    end
    render :json => {:status => status}
  end
end
