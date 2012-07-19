class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user 

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: 'microposts.created_at DESC'


  # def self.from_users_followed_by(user)
  #  followed_user_ids = user.followed_user_ids
  #  where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
 # end
#I think this means that if we call from_users_followed_by(x) on the Micropost class ('self'), we select using 'where' 
# on the Micropost class in the manner indicated - i.e., "user_id IN.. etc"
#problem with this is that all followed_user id's are put into memory (assigned as an array to variable followed_user_ids)
# note that we are just setting the variable followed_user_ids without let or anything else - we could just use 'x' as well,
# i.e. x = user.followed_user_ids
  #  where("user_id IN (?) OR user_id = ?", x, user)


def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end