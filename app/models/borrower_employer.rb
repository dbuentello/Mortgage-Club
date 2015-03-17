class BorrowerEmployer < ActiveRecord::Base
  belongs_to :borrower

  PERMITTED_ATTRS = [
    :borrower_id,
    :employer_name,
    :employer_address_id,
    :employment_contact_name,
    :employment_contact_number,
    :job_title,
    :months_at_employment,
    :years_at_employment,
    :is_current
  ]
end