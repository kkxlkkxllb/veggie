class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_seo_meta(title,keywords = '',desc = '')
    if title
      @title = "#{title}"
      @title += "&raquo;17UP"
    else
      @title = "17UP"
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
  
  def render_json(html)
    render :json => {
              :status => 0,
              :msg => "ok",
              :data => {
    			      :html => html
              }
            }
  end
end
