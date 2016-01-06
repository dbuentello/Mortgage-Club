class CreateNewInvite < ActiveRecord::Migration
  def change
    create_table :invites, id: :uuid do |t|
      t.string :email
      t.string :name
      t.string :phone, default: ''
      t.string :sender_id
      t.string :recipient_id
      t.string :token
      t.datetime :join_at
      t.timestamps
    end
    add_index :invites, :sender_id
  end
end