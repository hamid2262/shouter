class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :shouts
  has_many :followed_user_relationships, 
  					foreign_key: 'follower_id',
  					class_name: 'FollowingRelationship'
  has_many :followed_users, through: :followed_user_relationships

  has_many :follower_relationships,
  					foreign_key: 'followed_user_id',
  					class_name: 'FollowingRelationship'
  has_many :followers, through: :follower_relationships

  def name
    if self.username.nil?
      self.email
    else
      self.try(:username).titleize       
   end
  end
  
  def following? user
    self.followed_users.include? user
  end

  def follow user
    self.followed_users << user
  end
  def unfollow user
    self.followed_users.delete(user)     
  end
end
