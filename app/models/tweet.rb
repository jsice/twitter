class Tweet < ApplicationRecord
  belongs_to :user
  
  #replies
  belongs_to :parent, class_name: "Tweet", foreign_key: "reply_id", optional: true
  has_many :replies, class_name: "Tweet", foreign_key: "reply_id"
  
  #retweets
  has_many :users_retweets
  has_many :retweeters, through: :users_retweets, source: :user

  scope :replies, -> { where.not(reply_id: nil) }
  scope :tweets, -> { where(reply_id: nil) }

  def reply_to
    users = []
    current = parent
    while current.present?
      users << current.user
      current = current.parent
    end
    users.uniq
  end

  def parents
    tweets = []
    current = parent
    while current.present?
      tweets << current
      current = current.parent
    end
    tweets.reverse
  end

  def first_thread
    tweets = []
    current = replies
    until current.empty?
      tweets << current.first
      current = current.first.replies
    end
    tweets
  end
end
