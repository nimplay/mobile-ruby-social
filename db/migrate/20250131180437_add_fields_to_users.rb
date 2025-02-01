class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :nombre, :string
    add_column :users, :apellido, :string
    add_column :users, :username, :string
    add_column :users, :profile_pic, :binary 
  end
end
