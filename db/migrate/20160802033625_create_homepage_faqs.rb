class CreateHomepageFaqs < ActiveRecord::Migration
  def change
    create_table :homepage_faqs do |t|
      t.string :question
      t.text :anwser
      t.integer :hompage_faq_type_id

      t.timestamps null: false
    end
  end
end
