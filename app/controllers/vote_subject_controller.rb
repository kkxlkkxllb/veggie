# -*- coding: utf-8 -*-
class VoteSubjectController < ApplicationController
  def index
    set_seo_meta("生词本")
  end

  def new
  end

  def create
      
  end
  
  def insert_word
    if FetchWord.new(params[:word]).insert
      status = 0
    else
      status = -1
    end
    render :json => {:status => status}
  end
end
