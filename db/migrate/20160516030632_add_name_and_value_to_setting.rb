class AddNameAndValueToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :name, :string
    add_column :settings, :value, :string
  end
end
