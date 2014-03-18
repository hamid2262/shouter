class PhotoShout < ActiveRecord::Base

	has_many :shouts, as: :content
  has_many :comments, as: :commentable
 	
  has_attached_file :image,
    styles: lambda { |a| {:small => "x100>", :shout => "550x300>", :large => "x600>"} if a.instance.is_image? 
    	# {:small => "x200>", :medium => "x300>", :large => "x400>"} :	
    	# {:thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10}, 	
    	#  :medium => { :geometry => "300x300#", :format => 'jpg', :time => 10}
    	# }
    }
  
  validates :body, presence: true, length: {minimum: 5}
  
	validates_attachment :image, :size => { :in => 0..4.megabytes }
	  
  def owner
    self.shouts.first.owner  
  end

  def is_image?
    image.instance.image_content_type =~ %r(image)
  end

end


