class CreateLenders < ActiveRecord::Migration
  def change
    create_table :lenders, id: :uuid do |t|
      t.string :name
      t.string :website
      t.string :rate_sheet
      t.string :lock_rate_email
      t.string :docs_email
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.timestamps null: false
    end
  end
end
