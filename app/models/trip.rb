class Trip < ActiveRecord::Base
  belongs_to :driver, class_name: "User", foreign_key: "user_id"
  has_many   :subtrips
  accepts_nested_attributes_for :subtrips, allow_destroy: true

end
