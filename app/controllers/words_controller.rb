# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:only => :destroy
  def index
    set_seo_meta(t('words.title'),t('words.keywords'),t('words.describe'))
    @words = Word.all
  end
  
  def create
    @word = FetchWord.new(params[:word]).insert
  end
  
  def search
    input = params[:word]
    url = "http://api.wordreference.com/0.8/621ad/json/enzh/#{input}"
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
