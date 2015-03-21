json.borrower_government_monitoring_info do
  json.id                     @borrower_government_monitoring_info.id
  json.is_hispanic_or_latino  @borrower_government_monitoring_info.is_hispanic_or_latino
  json.gender_type            @borrower_government_monitoring_info.gender_type

  json.partial! 'borrowers/borrower_race', collection: @borrower_government_monitoring_info.borrower_races, as: :borrower_race
end
