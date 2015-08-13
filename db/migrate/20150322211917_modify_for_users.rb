class ModifyForUsers < ActiveRecord::Migration
  def change
    add_column :loans, :user_id, :uuid
    add_column :borrowers, :user_id, :uuid

    add_index :loans, :user_id
    add_index :borrowers, :user_id

    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
