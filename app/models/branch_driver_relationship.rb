class BranchDriverRelationship < ActiveRecord::Base
  belongs_to :driver, class_name: 'User', foreign_key: "user_id"
  belongs_to :branch

  validates :branch_id, presence: true
  validates :user_id, presence: true, :uniqueness => {:scope => :branch_id}
  
end
