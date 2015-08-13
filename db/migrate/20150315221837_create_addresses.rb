class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses, id: :uuid do |t|
      t.string  :street_address
      t.string  :secondary_street_address
      t.string  :zipcode
      t.integer :state
    end
  end
end
