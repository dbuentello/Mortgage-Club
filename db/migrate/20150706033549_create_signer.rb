class CreateSigner < ActiveRecord::Migration
  def change
    create_table :signers do |t|
      t.string :role_name
      t.uuid   :recipient_id
      t.uuid   :envelope_id
      t.uuid   :user_id
    end

    add_index :signers, :envelope_id
    add_index :signers, :user_id
  end
end
