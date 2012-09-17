# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:only => [:destroy,:create]
  def index
    set_seo_meta(t('words.title'),t('words.keywords'),t('words.describe'))
    @words = Word.all
  end
  
  def create
    @word = FetchWord.new(params[:word]).insert
  end
  
  def add_tag
    @word = Word.find(params[:id])
    @word.ctag_list = params[:tags].gsub("，",',')
    @word.save
  end
  
  # TO-DO destroy u_word
  def destroy
    @word = UWord.find(params[:id])
    if @word
      @word.del
      status = 0
    else
      status = -1
    end
    render :json => {:status => status}
  end
end
