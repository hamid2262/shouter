class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: {
    thumb: '80x80#',
    square: '200x200#',
    medium: '300x300>'
  }

  has_one    :vehicle

  has_many   :trips
  has_many   :bookings  
  belongs_to :city

  has_many :shouts
  has_many :followed_user_relationships, 
  					foreign_key: 'follower_id',
  					class_name: 'FollowingRelationship'
  has_many :followed_users, through: :followed_user_relationships

  has_many :follower_relationships,
  					foreign_key: 'followed_user_id',
  					class_name: 'FollowingRelationship'
  has_many :followers, through: :follower_relationships

  validates :firstname, length:   {maximum: 50}
  validates :lastname,  length:   {maximum: 50}
  validates :gender,    inclusion:{ in: %w(male female) } 

  after_create :send_admin_mail

  def send_admin_mail
    UserMailer.signup_confirmation(self).deliver
  end
  
  def name
    if self.firstname.present? || self.lastname.present?
      self.try(:firstname).try(:titleize) + " "+ self.try(:lastname).try(:titleize)
    elsif self.username.present?
       self.username
    else      
      self.email.partition("@").first 
   end
  end
  
  def online?
    updated_at > 10.minutes.ago
  end

  def is_admin?
    true if self.admin? || self.email == 'hamid2262@yahoo.com'  
  end

  def following? user
    self.followed_users.include? user
  end

  def can_follow? user
    self != user
  end

  def follow user
    self.followed_users << user
  end

  def unfollow user
    self.followed_users.delete(user)     
  end

end