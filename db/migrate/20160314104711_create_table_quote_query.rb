class CreateTableQuoteQuery < ActiveRecord::Migration
  def change
    create_table :quote_queries do |t|
      t.string :code_id, index: true
      t.text :query
    end
  end
end
