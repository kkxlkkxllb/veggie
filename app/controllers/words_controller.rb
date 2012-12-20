# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:except => [:index]

  def index       
    @courses = Course.all
    set_seo_meta(t('words.title'),t('words.keywords'),t('words.describe'))  
  end

  def course
    @course = Course.find(params[:id])
    @ctags = @course.ctags.split(";")
    @admin = current_member.admin? 
    @words = Rails.cache.fetch("course/#{@course.id}",:expires_in => 1.day) do 
      Word.tagged(@ctags).map(&:as_full_json)
    end
    @result = @words.map do |w|
       w.merge!(:got => current_member.has_u_word(w[:id]) ? true : false )
    end
    set_seo_meta(@course.title,t('words.keywords'),t('words.describe'))  
  end
  
  # 新建词汇
  # 1. 通过输入框传入单词
  # 2. 在文本区选择单词摘录
  def create
    unless @word = Word.where(:title => params[:word].downcase).first
      @word = Onion::FetchWord.new(word).insert
    end

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
  
  def u_create
    unless @word = Word.where(:title => params[:word].downcase).first
      @word = Onion::FetchWord.new(word).insert
    end
    if @word
      @u_word = current_member.u_words.create(:word_id => @word.id)
      render_json(0,"ok",@u_word.as_json)
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

	# Editor
  # Word ctag
  def add_tag
		@word = Word.find(params[:id])
		@word.ctag_list = Word.parse_tag(params[:tags]).join(",")
		if @word.save!
			render_json(0,"ok",{:tags => @word.hash_tags})
		else
			render_json(-1,"error")
		end
  end
  
	# Editor
  # quick img make
  def fetch_img   
    @word = Word.find(params[:id])
    @pics = Rails.cache.fetch("word/#{@word.id}/imgs",:expires_in => 1.weeks) do
        Grape::WordImage.new(@word.title).parse(@word.ctag_list.join(" "))[0..17]
      end
    img = @pics[rand(@pics.length)]
    Grape::WordImage.new(@word.title).make(img)
    render_json(0,"ok",{:pic => @word.image+"?#{Time.now.to_i}"})
  end
  
	# User
  # upload &image &id
  # response with js.haml
  def upload_img
		file = params[:image].tempfile.path
    type = params[:image].content_type
    @uw = UWord.find(params[:id])
		if @uw&&@uw.validate_upload_image(file,type)
    	status = Grape::UWordImage.new(@uw).make(file)
			@new_image = status == 0 ? (@uw.image + "?#{Time.now.to_i}") : false
		end
  end

	# User
	# input: img_url & id
	def select_img
		@status = Grape::UWordImage.new(params[:id]).make(params[:img_url])
		msg = @status < 0 ? "error img url" : "ok"
		render_json(@status,msg)
	end
  
  # TO-DO destroy u_word
  def destroy  
    if @word = UWord.find(params[:id])
      @word.destroy
      render_json(0,"ok")
    end
  end
end
