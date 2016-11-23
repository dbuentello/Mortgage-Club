class AddEncryptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_first_name, :string
    add_column :users, :encrypted_first_name_iv, :string
    add_column :users, :encrypted_last_name, :string
    add_column :users, :encrypted_last_name_iv, :string
  end
end
