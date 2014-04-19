class CacheFollowersCount < ActiveRecord::Migration
  def up
    execute "update users set followers_count=(select count(*) from following_relationships where followed_user_id=users.id)"
    execute "update users set followed_users_count=(select count(*) from following_relationships where follower_id=users.id)"
  end

  def down
  end

end
