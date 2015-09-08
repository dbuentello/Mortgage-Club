class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.string :name
      t.string :phone, default: ''
      t.string :sender_id
      t.string :recipient_id
      t.string :token
      t.timestamps
    end
  end
end
