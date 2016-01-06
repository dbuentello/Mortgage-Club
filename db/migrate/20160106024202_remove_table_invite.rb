class RemoveTableInvite < ActiveRecord::Migration
  def change
    drop_table :invites
  end
end
