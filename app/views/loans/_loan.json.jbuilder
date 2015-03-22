json.loan do
  json.id           loan.id
  json.purpose_type loan.purpose_type
  
  json.partial! 'properties/property', property: loan.property
  
  json.partial! 'borrowers/borrower', borrower: loan.borrower
  
  json.secondary_borrower do
    json.partial! 'borrowers/borrower', borrower: loan.secondary_borrower
  end
end
