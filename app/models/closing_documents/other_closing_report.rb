class OtherClosingReport < ClosingDocument
  belongs_to :closing, inverse_of: :other_closing_report, foreign_key: 'closing_id'
  belongs_to :owner, polymorphic: true
end
