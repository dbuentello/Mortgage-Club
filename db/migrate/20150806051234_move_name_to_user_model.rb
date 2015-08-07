class MoveNameToUserModel < ActiveRecord::Migration
  def change
    remove_column :borrowers, :first_name, :string
    remove_column :borrowers, :last_name, :string
    remove_column :borrowers, :middle_name, :string
    remove_column :borrowers, :suffix, :string

    remove_column :loan_members, :first_name, :string
    remove_column :loan_members, :last_name, :string
    remove_column :loan_members, :middle_name, :string

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :suffix, :string
  end
end
