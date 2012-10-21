class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def set_seo_meta(title,keywords = '',desc = '')
    if title
      @title = "#{title}"
      @title += "&raquo;"+t('title')
    else
      @title = t('title')
    end
    @subtitle = title
    @meta_keywords = keywords
    @meta_description = desc
  end
  
  def source_leafs(pid,page,per_page)    
    if page
      @pid = session[:pid]
    else
      session[:pid] = nil
      @pid = pid
    end
    session[:pid] = pid if pid
    @source_leafs = @pid.blank? ? Leaf : Provider.find(@pid).leafs
    return @source_leafs.includes(:provider).order("time_stamp DESC").page(page).per(per_page)
  end
  
  def render_json(status,msg,data = {})
    render :json => {
              :status => status,
              :msg => msg,
              :data => data
            }
  end
  
  def load_course(lang="en")
    YAML.load_file(Rails.root.join("lib/cherry", "course.yml")).fetch(lang)
  end
end
