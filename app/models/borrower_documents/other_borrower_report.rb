class OtherBorrowerReport < BorrowerDocument
  belongs_to :borrower, inverse_of: :other_borrower_report, foreign_key: 'borrower_id'
  belongs_to :owner, polymorphic: true
end
