module HomeHelper
  def contact_img_link(img_src,link,tooltip)
    link_to image_tag(img_src),link,:target=>"blank",:rel=>"tooltip",:title => tooltip
  end

end
