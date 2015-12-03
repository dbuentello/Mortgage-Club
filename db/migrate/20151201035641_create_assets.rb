class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets, id: :uuid do |t|
      t.string :institution_name
      t.integer :asset_type
      t.decimal :current_balance, :decimal, precision: 11, scale: 2
      t.uuid :borrower_id

      t.timestamps null: false
    end
  end
end
