class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :purpose_type
      t.integer :property_id
      t.integer :borrower_id
      t.integer :second_borrower_id
    end
  end
end