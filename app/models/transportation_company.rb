class TransportationCompany < ActiveRecord::Base

  has_attached_file :image, 
    styles: lambda { |a| {:thumb => "160x48#", :medium => "340x100#"} if a.instance.is_image? },
    default_url: lambda { |a| "#{IMAGES_PATH}#{a.instance.gender}_default_avatar.png"}

  has_attached_file :cover, 
    styles: lambda { |a| {:small => "370x140#", :large => "851x315#"} if a.instance.is_cover? },
    default_url:  "#{IMAGES_PATH}default_cover.jpg"

  def is_image?
    image.instance.image_content_type =~ %r(image)
  end

  def is_cover?
    cover.instance.cover_content_type =~ %r(image)
  end


end