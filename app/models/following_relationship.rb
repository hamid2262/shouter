class FollowingRelationship < ActiveRecord::Base
  belongs_to :follower,  class_name: 'User', counter_cache: :followers_count
  belongs_to :followed_user, class_name: 'User', counter_cache: :followed_users_count
end
