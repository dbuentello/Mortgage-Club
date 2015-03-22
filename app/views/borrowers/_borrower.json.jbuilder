json.borrower do
  json.id                     borrower.id
  json.first_name             borrower.first_name
  json.last_name              borrower.last_name
  json.middle_name            borrower.middle_name
  json.suffix                 borrower.suffix
  json.date_of_birth          borrower.date_of_birth
  json.social_security_number borrower.social_security_number
  json.phone_number           borrower.phone_number
  json.years_in_school        borrower.years_in_school
  json.marital_status_type    borrower.marital_status_type
  json.ages_of_dependents     borrower.ages_of_dependents
  json.gross_income           borrower.gross_income
  json.gross_overtime         borrower.gross_overtime
  json.gross_bonus            borrower.gross_bonus
  json.gross_commission       borrower.gross_commission

  json.partial! 'borrowers/borrower_address', collection: borrower.borrower_addresses, as: :borrower_address
  
  json.partial! 'borrowers/borrower_employer', collection: borrower.borrower_employers, as: :borrower_employer
  
  json.partial! 'borrowers/borrower_government_monitoring_info', borrower_government_monitoring_info: borrower.borrower_government_monitoring_info
end
