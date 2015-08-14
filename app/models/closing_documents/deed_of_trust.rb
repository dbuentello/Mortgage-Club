class DeedOfTrust < ClosingDocument
  DESCRIPTION = "Deed of Trust"

  belongs_to :closing, inverse_of: :deed_of_trust, foreign_key: 'closing_id'
  belongs_to :owner, polymorphic: true
end
