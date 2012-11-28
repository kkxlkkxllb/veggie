# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:except => [:index]
  
  # 外语教室
  # 按时间区间展示 1.week
  def index   
    course = load_course  
    @ctitle = "※ " + course['c1']['title'] + " ※"
    @ctags = course['c1']['ctags'].split(";")
    @words = Word.tagged(@ctags)
    if current_member and current_member.admin?
      @can_add_tag = true
    end
    set_seo_meta(t('words.title'),t('words.keywords'),t('words.describe'))
  end
  
  # 新建词汇
  # 1. 通过输入框传入单词
  # 2. 在文本区选择单词摘录
  def create
    word = params[:word].downcase
    admin = !params[:admin].blank?
    @word = Word.where(:title => word).first
    unless @word
      @word = Onion::FetchWord.new(word).insert
    end
    unless admin # 普通用户返回 u_word 对象 ，admin 返回 word
      @word = current_member.u_words.create(:word_id => @word.id)
    end
    @can_add_tag = true
    if @word
#      html = render_to_string(
#            :formats => :html,
#            :handlers => :haml,
#		        :partial => "word",
#		        :locals => {:w => @word}
#		        )
		  render_json(0,"ok",@word.as_json)
	  else
	    render_json(-1,"fail")
    end
  end
  
  # 克隆已有词汇到 u_words
  def clone
		@word = Word.find(params[:id])
		if uw = current_member.has_u_word(@word)
			uw.destroy
			render_json(1,"canceled")
		else
		  current_member.u_words.create(:word_id => @word.id)
    	render_json(0,"saved")
		end
  end

  
  def add_tag
		case params[:et]
		when "Word"
		  @_word = Word
		when "UWord"
			@_word = current_member.u_words
		end	
		if @_word && @word = @_word.where(:id => params[:id]).first
			@word.ctag_list = Word.parse_tag(params[:tags]).join(",")
			if @word.save!
			  render_json(0,"ok",{:title => @word.hash_tags})
			end
		else
			render_json(-1,"error")
		end
  end
  
  # quick img make
  def make_pic   
    @word = Word.find(params[:id])
    @pics = Rails.cache.fetch("word/#{@word.id}/imgs") do
        Grape::WordImage.new(@word.title).parse(@word.ctag_list.join(" "))[0..17]
      end
    img = @pics[rand(@pics.length)]
    Grape::WordImage.new(@word.title).make(img)
    render_json(0,"ok",{:pic => @word.image+"?#{Time.now.to_i}"})
  end
  
  # &image &id
  def upload_pic
    word = Word.find(params[:id])
		file = params[:image].tempfile.path
		if File.size(file) < UWord::IMAGE_SIZE_LIMIT
    	Grape::WordImage.new(word.title).make(file)
			render_json(0,"ok")
		else
			render_json(-1,"image too big,please resize it")
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
