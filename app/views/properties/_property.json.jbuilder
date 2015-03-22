json.property do
  json.id                         property.id
  json.property_type              property.property_type
  json.usage_type                 property.usage_type
  json.original_purchase_date     property.original_purchase_date
  json.original_purchase_price    property.original_purchase_price
  json.purchase_price             property.purchase_price
  json.gross_rental_income        property.gross_rental_income
  json.market_price               property.market_price
  json.estimated_property_tax     property.estimated_property_tax
  json.estimated_hazard_insurance property.estimated_hazard_insurance
  json.is_impound_account         property.is_impound_account
  
  json.partial! 'addresses/address', address: property.address
end
