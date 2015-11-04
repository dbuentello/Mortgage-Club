class AddUserInputToLiabilities < ActiveRecord::Migration
  def change
    add_column :liabilities, :user_input, :boolean, default: false
  end
end
