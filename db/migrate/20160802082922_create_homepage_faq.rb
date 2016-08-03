class CreateHomepageFaq < ActiveRecord::Migration
  def change
    create_table :homepage_faqs, id: :uuid  do |t|
      t.references :homepage_faq_type, index: true, foreign_key: true, type: :uuid
      t.string :question
      t.text :answer

      t.timestamps null: false
    end
  end
end
