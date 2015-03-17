class CreateBorrowers < ActiveRecord::Migration
  def change
    create_table :borrowers do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :middle_name
      t.string    :suffix
      t.datetime  :date_of_birth
      t.binary    :social_security_number
      t.string    :phone_number
      t.integer   :years_in_school
      t.integer   :marital_status_type
      t.integer   :ages_of_dependents, array: true, default: []
      t.decimal   :gross_income, :precision => 13, :scale => 2
      t.decimal   :gross_overtime, :precision => 11, :scale => 2
      t.decimal   :gross_bonus , :precision => 11, :scale => 2
      t.decimal   :gross_commission, :precision => 11, :scale => 2
    end

    create_table :borrower_addresses do |t|
      t.integer :borrower_id
      t.integer :address_id
      t.integer :years_at_address
      t.boolean :is_rental
      t.boolean :is_current
    end

    create_table :borrower_employers do |t|
      t.integer :borrower_id
      t.string  :employer_name
      t.integer :employer_address_id
      t.string  :employment_contact_name
      t.string  :employment_contact_number
      t.string  :job_title
      t.integer :months_at_employment
      t.integer :years_at_employment
      t.boolean :is_current
    end

    create_table :borrower_government_monitoring_info do |t|
      t.integer :borrower_id
      t.boolean :hispanic_or_latino
      t.integer :gender_type
    end

    # creating table for race because we can select multiple race_types per borrower
    create_table :borrower_race do |t|
      t.integer :borrower_government_monitoring_info_id
      t.integer :race_type
    end

    add_index :borrower_addresses, :borrower_id
    add_index :borrower_addresses, :address_id
    add_index :borrower_employers, :borrower_id
    add_index :borrower_employers, :employer_address_id
    add_index :borrower_government_monitoring_info, :borrower_id
    add_index :borrower_race, :borrower_government_monitoring_info_id
  end
end