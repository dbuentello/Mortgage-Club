class AddIsSubjectColumnToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :is_subject, :boolean, default: false
  end
end
