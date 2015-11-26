class AddSelfEmployedToBorrowers < ActiveRecord::Migration
  def change
    add_column :borrowers, :self_employed, :boolean, default: false
  end
end
