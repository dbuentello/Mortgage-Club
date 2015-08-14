class LoanDoc < ClosingDocument
  DESCRIPTION = "Loan Document"

  belongs_to :closing, inverse_of: :loan_doc, foreign_key: 'closing_id'
  belongs_to :owner, polymorphic: true
end
