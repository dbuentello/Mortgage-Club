class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans, id: :uuid do |t|
      t.integer :purpose_type
      t.uuid    :property_id
      t.uuid    :borrower_id
      t.uuid    :second_borrower_id
    end
  end
end