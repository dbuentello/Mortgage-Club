class ChangeBorrowerFieldName < ActiveRecord::Migration
  def change
    rename_column :borrowers, :date_of_birth, :dob
    rename_column :borrowers, :social_security_number, :ssn
    rename_column :borrowers, :marital_status_type, :marital_status
    rename_column :borrowers, :phone_number, :phone
  end
end
