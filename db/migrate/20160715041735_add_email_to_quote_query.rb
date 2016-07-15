class AddEmailToQuoteQuery < ActiveRecord::Migration
  def change
    add_column :quote_queries, :email, :string
  end
end
