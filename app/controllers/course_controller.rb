class CourseController < ApplicationController
  before_filter :authenticate_member!,:except => [:index]
  
  def index       
    @courses = Course.all.map(&:as_json)
    set_seo_meta(t('center.title'),t('center.keywords'),t('center.describe'))  
  end
  
  # To-Do
  # Course New
  # 权限要求：a e
  # 直接新建课程，基本元素是单词，word,不生成u_word 
  def new
    set_seo_meta(t('course.new'))
  end

  def show
    @course = Course.find(params[:id])
    @ctags = @course.ctags.split(";")
    @admin = current_member.admin?  
    @result = @course.words
    set_seo_meta(@course.title)
  end
  
  def create
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
end
