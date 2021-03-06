class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy

  #retweets
  has_many :users_retweets, dependent: :destroy
  has_many :retweets, through: :users_retweets, source: :tweet

  #likes
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  #followers
  has_many :user_followers, foreign_key: "follower_id", class_name: "UserFollower", dependent: :destroy
  has_many :followings, through: :user_followers
  has_many :user_followings, foreign_key: "following_id", class_name: "UserFollower", dependent: :destroy
  has_many :followers, through: :user_followings

  def all_tweets
    (tweets.tweets + retweets).uniq.sort_by { |tweet| tweet.published_at } .reverse
  end

  def related_users (n=3)
    my_tags = get_hashtags_from(tweets)
    User.where.not(id: id).sort_by { |u| (my_tags - get_hashtags_from(u.tweets)).length } [0...n]
  end

  private

  def get_hashtags_from(tweets)
    tweets.tag_counts_on(:hashtags).pluck(:id)
  end
end
