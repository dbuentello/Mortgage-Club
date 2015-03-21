class BorrowerRace < ActiveRecord::Base
  belongs_to :borrower_government_monitoring_info, inverse_of: :borrower_races, foreign_key: 'borrower_government_monitoring_info_id'
  
  PERMITTED_ATTRS = [
    :race_type
  ]

  enum race_type: {
    american_indian: 0,
    alaska_native_or_asian_or_black: 1,
    african_american_or_native_hawaiian: 2,
    other_pacific_islander: 3,
    white: 4
  }
end