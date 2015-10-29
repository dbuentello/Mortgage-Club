class AddColumnsToEmployment < ActiveRecord::Migration
  def change
    add_column :employments, :current_salary, :decimal, :precision => 11, :scale => 2
    add_column :employments, :ytd_salary, :decimal, :precision => 11, :scale => 2
  end
end
