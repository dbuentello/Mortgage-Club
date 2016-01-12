class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs, id: :uuid do |t|
      t.text :question
      t.text :answer

      t.timestamps null: false
    end
  end
end
