# coding: utf-8
class WordsController < ApplicationController
  before_filter :authenticate_member!,:except => [:upload_mov]
  
  # 单词联想 u_word
  # current_member & word_id
  # type 1: content
  # type 2: images
  # type 3: audios
  def imagine
    @word = Word.find(params[:id])
    @uw = current_member.has_u_word(@word)      
    case params[:type].to_i
    when 1
      data = @uw ? @uw.content : nil
    when 2
      data = @word.rich_images
    when 3
      r_audios = @word.u_words.select{|x| x.has_audio }.collect{|w| w.audio_url}
      u_audio = @uw && (@uw.has_audio ? @uw.audio_url : nil)
      data = {:me => u_audio,:imagine => r_audios}
    end 
    render_json 0,'ok',data
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
  
	# Word
  # 权限：a
  # 为课程中的词汇选择图片，图源：Bing Search & Olive
  def fetch_img
    @word = Word.find(params[:id])
    Grape::WordImage.new(@word.title).make(params[:img])
    render_json(0,"ok",{:pic => @word.image+"?#{Time.now.to_i}"})
  end
  
  # C Word
  # 权限 e a
  # 上传图片，为c_word合成图
  def upload_img_c
    @cw = find_or_create_cw(params[:id])
    file = params[:image].tempfile.path
    type = params[:image].content_type
  end
  
	# U Word
	# 用户上传图片
  # upload &image &id
  # response with js.haml
  def upload_img_u
    @uw = find_or_create_uw(params[:id])
		file = params[:image].tempfile.path
    type = params[:image].content_type
		if @uw&&@uw.validate_upload_image(file,type)
    	status = Grape::UWordImage.new(@uw).make(file)
			@new_image = status == 0 ? (@uw.image + "?#{Time.now.to_i}") : false
		end	
  end
  
  # U word
  # 自定义注释
  def annotate_u
    @uw = find_or_create_uw(params[:id])
    @uw.content = params[:annotate]
    @uw.save
    render_json 0,"ok"
  end

  # U word
  # 个人发音,自动上传
  def upload_audio_u
    @uw = find_or_create_uw(params[:id])
    file = params[:file]
    @store_path = UWord::AUDIO_PATH + "#{@uw.id}"
    unless File.exist?(@store_path)
      `mkdir -p #{@store_path}`
    end
    # 压缩成 ogg
    `oggenc -q 4 #{file.tempfile.path} -o #{@uw.audio_path}`
    render_json 0,"ok"
  end

	# U word
	# To-Do
	# 用户上传视频
	# &mov
	def upload_mov_u
		file = params[:mov]
		data = open(file.tempfile.path){|f|f.read}
    file = File.open(File.join("public/system",file.original_filename),"wb") << data
    file.close
	end

	# U Word
	# 用户图片选取：从自己关联身份instagram，tumblr取
	# input: img_url & id
  # json
	def select_img_u
    @uw = find_or_create_uw(params[:id])
		status = Grape::UWordImage.new(@uw).make(params[:img_url])
    if status == 0
      @new_image = @uw.image + "?#{Time.now.to_i}"
      render_json 0,"ok",@new_image
    else
		  render_json status,"error"
    end
	end
  
  # TO-DO destroy u_word
  def destroy_u  
    if @word = UWord.find(params[:id])
      @word.destroy
      render_json(0,"ok")
    end
  end
  
  private
  def find_or_create_uw(id)
    @word = Word.find(id)
    unless @uw = current_member.has_u_word(@word)
      @uw = current_member.u_words.create(:word_id => @word.id)
    end
    @uw
  end
  
  def find_or_create_cw(id)
    @word = Word.find(id)
  end
end
