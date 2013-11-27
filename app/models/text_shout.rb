class TextShout < ActiveRecord::Base

  validates :body, presence: true, length: { in: 6..140 }

end
