# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:except => :index
  
  # 外语教室
  # 按时间区间展示 1.week
  def index
    set_seo_meta(t('words.title'),t('words.keywords'),t('words.describe'))
    
    @words = Word.vall
  end
  
  # 新建词汇
  # 1. 通过输入框传入单词
  # 2. 在文本区选择单词摘录
  def create
    word = params[:word].downcase
    admin = !params[:admin].blank?
    @word = Word.where(:title => word).first
    unless @word
      @word = FetchWord.new(word).insert
    end
    unless admin # 普通用户返回 u_word 对象 ，admin 返回 word
      @word = current_member.u_words.create(:word_id => @word.id)
    end
    html = render_to_string(
            :formats => :html,
            :handlers => :haml,
		        :partial => "word",
		        :locals => {:w => @word}
		        )
		render_json(0,"ok",{:html => html})
  end
  
  # 克隆已有词汇到 u_words
  def clone
    @word = Word.find(params[:id])
    current_member.u_words.create(:word_id => @word.id)
    render_json(0,"ok")
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
