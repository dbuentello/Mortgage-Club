class CreateRateComparison < ActiveRecord::Migration
  def change
    create_table :rate_comparisons, id: :uuid do |t|
      t.references :loan, index: true, foreign_key: true, type: :uuid
      t.string :lender_name
      t.float :down_payment_percentage
      t.text :rates
    end
  end
end
