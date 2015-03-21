json.borrower_employer do
  json.id                       @borrower_employer.id
  json.employer_name            @borrower_employer.employer_name
  json.employer_contact_name    @borrower_employer.employer_contact_name
  json.employer_contact_number  @borrower_employer.employer_contact_number
  json.job_title                @borrower_employer.job_title
  json.months_at_employer       @borrower_employer.months_at_employer
  json.years_at_employer        @borrower_employer.years_at_employer
  json.is_current               @borrower_employer.is_current

  json.partial! 'addresses/address', address: @borrower_employer.address
end
