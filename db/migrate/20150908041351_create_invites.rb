class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.string :name
      t.string :phone, default: ''
      t.integer :sender_id
      t.integer :recipient_id
      t.string :token
      t.timestamps
    end
  end
end
