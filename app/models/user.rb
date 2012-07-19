# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

=begin
class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

before_save { |user| user.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  			uniqueness: { case_sensitive: false }


end
=end

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation 
  has_secure_password

  has_many :microposts, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # this defines the set of all relationships in which the user's ID = follower_id (in which user is the follower)
  # Does this tell rails to assign the ID for a user to follower_id slot for a relationship when that relationship is crated for a user?
  has_many :followed_users, through: :relationships, source: :followed
  # this says the user has a bunch of entities (users, called 'followed_users') defined by having an ID = followed_id in that user's
  # 'relationships' (as defined above)

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  # this defines the set of all (reverse) relationships in which the user's ID = followed_id (in which the user is followed)
  has_many :followers, through: :reverse_relationships, source: :follower
  # this says that the user has a bunch of entities (users, called 'followers') defined by having an ID = follower_id in 
  # that user's 'reverse relationships' (as defined above)
  # could also use 'has_many :followers, through: :reverse_relationships' here b/c rails will drop the 's' and look 
  # for follower_id as the source by default

 before_save { self.email.downcase! }
# #same as# before_save { |user| user.email = email.downcase }
before_save :create_remember_token



  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true


def feed
     #This is preliminary. See "Following users" for the full implementation.
    #Micropost.where("user_id = ?", id)
    # this (above) says if you take the 'feed' method on a user, retrn all microposts (an array) where...
    #this allows stuff like current_user.feed
    # note: question mark ensures that id is properly escaped before being included in the underlying SQL query,
    # thereby avoiding a serious security hole called SQL injection.
    Micropost.from_users_followed_by(self)
end


def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  # I think this says if we run following?(x) on y [i.e., y.following?(x)], 
  # we get y.relationships.find_by_followed_id(x.id) - that is, take the relationships
  # belonging to y, and see if x's id is one of the followed_id's in those relationships
  # but what does this return? the relationship? i guess if the relatinship doesn't exist,
  # it returns nil or false?  
  #can we put self at the beginning here?

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  #equivalent code is self.relationships.create!(...)

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  # can we put self at the beginning here?

    private

      def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
      end
    # need we put self at the beginning here? why?

end