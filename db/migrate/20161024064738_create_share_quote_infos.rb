class CreateShareQuoteInfos < ActiveRecord::Migration
  def change
    create_table :share_quote_infos do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :quote_link

      t.timestamps null: false
    end
  end
end
