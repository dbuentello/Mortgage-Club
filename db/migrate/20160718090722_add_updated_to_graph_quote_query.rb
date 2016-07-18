class AddUpdatedToGraphQuoteQuery < ActiveRecord::Migration
  def change
    add_column :graph_quote_queries, :g_updated, :boolean
  end
end
