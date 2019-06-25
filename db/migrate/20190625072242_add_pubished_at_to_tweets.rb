class AddPubishedAtToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :published_at, :timestamp, default: -> { 'CURRENT_TIMESTAMP' }, null: false
  end
end
