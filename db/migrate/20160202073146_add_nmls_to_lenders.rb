class AddNmlsToLenders < ActiveRecord::Migration
  def change
    add_column :lenders, :nmls, :string
  end
end
