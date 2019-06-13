class CreateUsersRetweets < ActiveRecord::Migration[6.0]
  def change
    create_table :users_retweets do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :tweet, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
