class AddFieldsToActivityTypes < ActiveRecord::Migration
  def change
    add_column :activity_types, :notify_borrower_email, :boolean
    add_column :activity_types, :notify_borrower_text, :boolean
    add_column :activity_types, :notify_borrower_email_subject, :text
    add_column :activity_types, :notify_borrower_email_body, :text
    add_column :activity_types, :notify_borrower_text_body, :text
  end
end
