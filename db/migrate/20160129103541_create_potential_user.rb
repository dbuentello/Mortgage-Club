class CreatePotentialUser < ActiveRecord::Migration
  def change
    create_table :potential_users, id: :uuid do |t|
      t.string :email
      t.string :name
      t.string :phone_number
      t.has_attached_file :mortgage_statement
      t.timestamps
    end
  end
end
