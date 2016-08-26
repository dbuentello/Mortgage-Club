class RemoveTypeNameMappingFromActivityType < ActiveRecord::Migration
  def change
    remove_column :activity_types, :type_name_mapping
    remove_column :activity_types, :notify_borrower_email
    remove_column :activity_types, :notify_borrower_text
    remove_column :activity_types, :notify_borrower_email_subject
    remove_column :activity_types, :notify_borrower_email_body
    remove_column :activity_types, :notify_borrower_text_body
  end
end
