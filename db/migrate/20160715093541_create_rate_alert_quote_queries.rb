class CreateRateAlertQuoteQueries < ActiveRecord::Migration
  def change
    create_table :rate_alert_quote_queries do |t|
      t.string :code_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.references :quote_query, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
