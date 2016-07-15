class AddMoreFieldToRateAlertQuoteQuery < ActiveRecord::Migration
  def change
    add_column :rate_alert_quote_queries, :apr, :decimal
    add_column :rate_alert_quote_queries, :rate, :float
    add_column :rate_alert_quote_queries, :lender_credit, :decimal
    add_column :rate_alert_quote_queries, :estimated_3_party_fees, :decimal
  end
end
