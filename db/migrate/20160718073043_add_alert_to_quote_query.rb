class AddAlertToQuoteQuery < ActiveRecord::Migration
  def change
    add_column :quote_queries, :alert, :boolean, :default => false
  end
end
