module HomeHelper
  def contact_img_link(img_src,link,tip)
    link_to image_tag(img_src),link,:target=>"blank",:title => tip
  end

end
