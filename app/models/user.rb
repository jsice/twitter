class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy

  #retweets
  has_many :users_retweets
  has_many :retweets, through: :users_retweets, source: :tweet

  def all_tweets
    (tweets.tweets + retweets).uniq.sort.reverse
  end
end
