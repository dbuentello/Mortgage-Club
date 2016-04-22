class CreateFacebookData < ActiveRecord::Migration
  def change
    create_table :facebook_data, id: :uuid do |t|
      t.string :purpose
      t.decimal :down_payment, precision: 13, scale: 2
      t.decimal :property_value, precision: 13, scale: 2
      t.string :property_type
      t.string :usage
      t.string :zipcode
      t.decimal :mortgage_balance, precision: 13, scale: 2
      t.integer :credit_score
      t.string :first_name
      t.string :last_name
      t.string :facebook_id
      t.string :conversation_id
      t.text :profile_pic
      t.text :resolved_queries
      t.timestamps null: false
    end
  end
end
