class AddLogoFieldToLender < ActiveRecord::Migration
  def change
    add_attachment :lenders, :logo
  end
end
