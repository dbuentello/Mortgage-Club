class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages, id: :uuid do |t|
      t.string :token
      t.string :to
      t.references :user, index: true, foreign_key: true, type: :uuid
      t.references :loan, index: true, foreign_key: true, type: :uuid
      t.text :subject
      t.text :content
      t.datetime :opened_at
      t.datetime :clicked_at

      t.timestamps null: false
    end
  end
end
