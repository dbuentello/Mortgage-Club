class CreateDeclarations < ActiveRecord::Migration
  def change
    create_table :declarations, id: :uuid do |t|
      t.boolean :outstanding_judgment
      t.boolean :bankrupt
      t.boolean :property_foreclosed
      t.boolean :party_to_lawsuit
      t.boolean :loan_foreclosure
      t.boolean :present_deliquent_loan
      t.boolean :child_support
      t.boolean :down_payment_borrowed
      t.boolean :co_maker_or_endorser
      t.boolean :us_citizen
      t.boolean :permanent_resident_alien
      t.boolean :ownership_interest
      t.string :type_of_property
      t.string :title_of_property
      t.timestamps null: false
      t.references :borrower, index: true, foreign_key: true, type: :uuid
    end
  end
end
