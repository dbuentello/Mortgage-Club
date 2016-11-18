class AddFieldsToMessage < ActiveRecord::Migration
  def change
    add_timestamps :messages, null: false
  end
end
