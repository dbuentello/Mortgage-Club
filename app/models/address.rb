class Address < ActiveRecord::Base
  belongs_to :property, inverse_of: :address, foreign_key: 'property_id'
  belongs_to :borrower_address, inverse_of: :address, foreign_key: 'borrower_address_id'
  belongs_to :borrower_employer, inverse_of: :address, foreign_key: 'borrower_employer_id'

  PERMITTED_ATTRS = [
    :street_address,
    :secondary_street_address,
    :zipcode,
    :state_type
  ]

  enum state_type: {
    alabama: 0,
    alaska: 1,
    arizona: 2,
    arkansas: 3,
    california: 4,
    colorado: 5,
    connecticut: 6,
    delaware: 7,
    florida: 8,
    georgia: 9,
    hawaii: 10,
    idaho: 11,
    illinois: 12,
    indiana: 13,
    iowa: 14,
    kansas: 15,
    kentucky: 16,
    louisiana: 17,
    maine: 18,
    maryland: 19,
    massachusetts: 20,
    michigan: 21,
    minnesota: 22,
    mississippi: 23,
    missouri: 24,
    montana: 25,
    nebraska: 26,
    nevada: 27,
    new_hampshire: 28,
    new_jersey: 29,
    new_mexico: 30,
    new_york: 31,
    north_carolina: 32,
    north_dakota: 33,
    ohio: 34,
    oklahoma: 35,
    oregon: 36,
    pennsylvania: 37,
    rhode_island: 38,
    south_carolina: 39,
    south_dakota: 40,
    tennessee: 41,
    texas: 42,
    utah: 43,
    vermont: 44,
    virginia: 45,
    washington: 46,
    west_virginia: 47,
    wisconsin: 48,
    wyoming: 49
  }
end
