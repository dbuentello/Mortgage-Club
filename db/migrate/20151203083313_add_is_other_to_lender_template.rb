class AddIsOtherToLenderTemplate < ActiveRecord::Migration
  def change
    add_column :lender_templates, :is_other, :boolean, default: false
  end
end
