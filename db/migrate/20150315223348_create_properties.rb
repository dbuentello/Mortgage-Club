class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer   :address_id
      t.integer   :property_type
      t.integer   :usage_type
      t.datetime  :original_purchase_date
      # -99,999,999,999.99 to 99,999,999,999.99
      t.decimal   :original_purchase_price,    :precision => 13, :scale => 2
      t.decimal   :purchase_price,             :precision => 13, :scale => 2
      t.decimal   :market_price,               :precision => 13, :scale => 2
      # optional....only if we are renting out the new property
      # -999,999,999.99 to 999,999,999.99
      t.decimal   :gross_rental_income,        :precision => 11, :scale => 2
      t.decimal   :estimated_property_tax,     :precision => 11, :scale => 2
      t.decimal   :estimated_hazard_insurance, :precision => 11, :scale => 2
      t.boolean   :impound_account
    end

    add_index :properties, :address_id
  end
end