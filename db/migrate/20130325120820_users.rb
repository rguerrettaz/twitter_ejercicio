class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :access_token, :access_token_secret
      t.datetime :cached_at
      t.integer :twitter_id
      t.timestamps
    end
  end
end
