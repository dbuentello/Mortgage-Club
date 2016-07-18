class AddOrderNumberToActivityTypes < ActiveRecord::Migration
  def change
    add_column :activity_types, :order_number, :integer
  end
end
