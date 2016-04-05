class AddMoreFieldsToQuoteQuery < ActiveRecord::Migration
  def change
    add_column :quote_queries, :email, :string
    add_column :quote_queries, :name, :string
  end
end
