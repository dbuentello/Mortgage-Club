class CreateSigner < ActiveRecord::Migration
  def change
    create_table :signers do |t|
      t.string :role_name
      t.integer :recipient_id
      t.integer :envelope_id
      t.integer :user_id
    end

    add_index :signers, :envelope_id
    add_index :signers, :user_id
  end
end
