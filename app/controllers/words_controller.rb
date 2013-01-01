# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:except => [:index]

  def index       
    @courses = Course.all
    set_seo_meta(t('center.title'),t('center.keywords'),t('center.describe'))  
  end

  # Course show
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
    set_seo_meta(@course.title)  
  end
  
  # To-Do
  # Course New
  # 权限要求：a e
  # 直接新建课程，基本元素是单词，word,不生成u_word 
  def new
    set_seo_meta(t('course.new'))
  end
  
  # Course Word New 
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
  
  # 未开放
  # U Word New
  # 权限要求：b v g 
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
  
  # create or destroy u_word
  # input &id
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
  
  # Re-work
	# Word
  # 权限：e a
  # 为课程中的词汇选择图片，图源：Bing Search & Olive
  def fetch_img
    @word = Word.find(params[:id])
    Grape::WordImage.new(@word.title).make(params[:img])
    render_json(0,"ok",{:pic => @word.image+"?#{Time.now.to_i}"})
  end
  
	# U Word
	# 用户上传图片
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

	# U Word
	# 用户图片选取：从自己关联身份instagram，tumblr取
	# input: img_url & id
  # json
	def select_img
    @uw = UWord.find(params[:id])
		status = Grape::UWordImage.new(@uw).make(params[:img_url])
    if status == 0
      @new_image = @uw.image + "?#{Time.now.to_i}"
      render_json 0,"ok",@new_image
    else
		  render_json status,"error"
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
