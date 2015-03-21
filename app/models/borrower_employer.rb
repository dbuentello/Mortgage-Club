class BorrowerEmployer < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :borrower_employers, foreign_key: 'borrower_id'
  has_one :address, inverse_of: :borrower_employer
  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :borrower_id,
    :employer_name,
    :employer_contact_name,
    :employer_contact_number,
    :job_title,
    :months_at_employer,
    :years_at_employer,
    :is_current,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]
end