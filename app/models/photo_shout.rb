class PhotoShout < ActiveRecord::Base

	has_many :shouts, as: :content

 	has_attached_file :image,
    styles: lambda { |a| {:small => "x100>", :shout => "x300>", :large => "x600>"} if a.instance.is_image? 
    	# {:small => "x200>", :medium => "x300>", :large => "x400>"} :	
    	# {:thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10}, 	
    	#  :medium => { :geometry => "300x300#", :format => 'jpg', :time => 10}
    	# }
    }
    
	validates_attachment :image, :presence => true,
	  :size => { :in => 0..1.megabytes }
	  
  def is_image?
          image.instance.image_content_type =~ %r(image)
  end

end


