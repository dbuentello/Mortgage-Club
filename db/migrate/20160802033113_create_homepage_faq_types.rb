class CreateHomepageFaqTypes < ActiveRecord::Migration
  def change
    create_table :homepage_faq_types, id: :uuid do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
