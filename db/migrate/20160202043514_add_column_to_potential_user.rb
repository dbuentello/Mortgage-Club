class AddColumnToPotentialUser < ActiveRecord::Migration
  def change
    add_column :potential_users, :send_as_email, :boolean
    add_column :potential_users, :send_as_text_message, :boolean
  end
end
