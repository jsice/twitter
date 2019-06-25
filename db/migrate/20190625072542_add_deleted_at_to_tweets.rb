class AddDeletedAtToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :deleted_at, :timestamp
  end
end
