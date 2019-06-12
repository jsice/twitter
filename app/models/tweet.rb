class Tweet < ApplicationRecord
  belongs_to :user
  
  belongs_to :parent, class_name: "Tweet", foreign_key: "reply_id", optional: true
  has_many :replies, class_name: "Tweet", foreign_key: "reply_id"

  scope :replies, -> { where.not(reply_id: nil) }
  scope :tweets, -> { where(reply_id: nil) }
end
