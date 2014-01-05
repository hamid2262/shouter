class PhotoShout < ActiveRecord::Base

	has_many :shouts, as: :content

	has_attached_file :image, styles: {
		shout: "200x200>"
	}

	validates :image, presence: true
	  # has_attached_file :image, :styles => { 
	  # :medium => "300x300>", :thumb => "100x100>" 
	  # }, :default_url => "/images/:style/missing.png"

end
