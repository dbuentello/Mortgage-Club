class AddFieldsToDeclarations < ActiveRecord::Migration
  def change
    add_column :declarations, :is_hispanic_or_latino, :text
    add_column :declarations, :gender_type, :text
    add_column :declarations, :race_type, :text
  end
end
