# -*- coding: utf-8 -*-
class VoteSubjectController < ApplicationController
  def index
    set_seo_meta("生词本")
    @words = Word.all
  end

  def new
  end

  def create
      
  end
  
  def insert_word
    @word = FetchWord.new(params[:word]).insert
  end
end
