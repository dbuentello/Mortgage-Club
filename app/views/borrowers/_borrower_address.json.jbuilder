json.borrower_address do
  json.id               borrower_address.id
  json.years_at_address borrower_address.years_at_address
  json.is_rental        borrower_address.is_rental
  json.is_current       borrower_address.is_current
  
  json.partial! 'addresses/address', address: borrower_address.address
end
