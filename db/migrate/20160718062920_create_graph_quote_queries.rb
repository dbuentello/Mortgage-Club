class CreateGraphQuoteQueries < ActiveRecord::Migration
  def change
    create_table :graph_quote_queries do |t|
      t.text :year30
      t.text :year15
      t.text :arm71
      t.text :arm51
      t.references :quote_query, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
