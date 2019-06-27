class Tweet < ApplicationRecord
  validates :content, presence: true, length: { maximum: 256 }
  
  acts_as_taggable_on :hashtags

  before_save :add_hashtags
  before_save :set_published_at

  belongs_to :user
  
  #replies
  belongs_to :parent, class_name: "Tweet", foreign_key: "reply_id", optional: true
  has_many :replies, class_name: "Tweet", foreign_key: "reply_id"
  
  #retweets
  has_many :users_retweets
  has_many :retweeters, through: :users_retweets, source: :user

  #likes
  has_many :likes
  has_many :liking_users, through: :likes, source: :user

  #retweet_with_comment
  belongs_to :commentee, class_name: "Tweet", foreign_key: "tweet_id", optional: true
  has_many :commenters, class_name: "Tweet", foreign_key: "tweet_id"

  scope :replies, -> { where.not(reply_id: nil) }
  scope :tweets, -> { where(reply_id: nil) }
  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :not_deleted, -> { where.not('deleted_at <= ?', Time.current).or(where(deleted_at: nil)) }
  scope :present, -> { published.not_deleted }

  def reply_to
    users = []
    current = parent
    while current.present?
      users << current.user
      current = current.parent
    end
    users.uniq
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

  def self.search(term)
    where("content LIKE ?", "%#{term}%")
  end

  private

  def add_hashtags
    hashtags = content.scan(/(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/i)
    hashtag_list.add(hashtags)
  end

  def set_published_at
    self.published_at = Time.now if self.published_at.nil?
  end
end
