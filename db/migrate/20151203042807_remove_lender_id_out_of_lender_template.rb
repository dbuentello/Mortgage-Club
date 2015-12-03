class RemoveLenderIdOutOfLenderTemplate < ActiveRecord::Migration
  def change
    remove_column :lender_templates, :lender_id
  end
end
