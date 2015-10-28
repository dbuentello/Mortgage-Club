class AddPayFrequencyToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :pay_frequency, :string
  end
end
