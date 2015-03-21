json.address do
  json.id                       @address.id
  json.street_address           @address.street_address
  json.secondary_street_address @address.secondary_street_address
  json.zipcode                  @address.zipcode
  json.state_type               @address.state_type
end
