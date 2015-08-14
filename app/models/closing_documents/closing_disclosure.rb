class ClosingDisclosure < ClosingDocument
  DESCRIPTION = "Closing Disclosure"

  belongs_to :closing, inverse_of: :closing_disclosure, foreign_key: 'closing_id'
  belongs_to :owner, polymorphic: true
end
