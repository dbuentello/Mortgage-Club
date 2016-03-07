class CreatePotentialRateDropUsers < ActiveRecord::Migration
  def change
    create_table :potential_rate_drop_users do |t|
      t.string :email
      t.string :phone_number
      t.integer :refinance_purpose
      t.decimal :current_mortgage_balance
      t.float :current_mortgage_rate
      t.decimal :estimate_home_value
      t.string :zip
      t.integer :credit_score
      t.boolean :send_as_email
      t.boolean :send_as_text_message

      t.timestamps null: false
    end
  end
end
