class CreateActivityNames < ActiveRecord::Migration
  def change
    create_table :activity_names, id: :uuid do |t|
      t.boolean :notify_borrower_email
      t.boolean :notify_borrower_text
      t.text :notify_borrower_email_subject
      t.text :notify_borrower_email_body
      t.text :notify_borrower_text_body
      t.string :name

      t.timestamps null: false
    end
  end
end
