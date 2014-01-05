class TextShout < ActiveRecord::Base

	has_many :shouts, as: :content
  validates :body, presence: true, length: { in: 6..140 }

end
