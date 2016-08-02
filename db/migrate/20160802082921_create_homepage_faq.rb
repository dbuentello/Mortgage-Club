class CreateHomepageFaq < ActiveRecord::Migration
  def change
    create_table :homepage_faqs, id: :uuid  do |t|
      t.string :homepage_faq_type_id
      t.string :question
      t.text :answer

      t.timestamps null: false
    end
  end
end
