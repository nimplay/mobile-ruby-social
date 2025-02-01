class CreateFriends < ActiveRecord::Migration[7.2]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :friend, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friends, [:user_id, :friend_id], unique: true
    add_index :friends, [:friend_id, :user_id], unique: true
  end
end
