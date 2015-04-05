class FixNames < ActiveRecord::Migration
  def change
    rename_column :properties, :usage_type, :usage
    rename_column :loans, :purpose_type, :purpose
  end
end
