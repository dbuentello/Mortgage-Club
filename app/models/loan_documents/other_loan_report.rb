class OtherLoanReport < LoanDocument
  belongs_to :loan, inverse_of: :other_loan_report, foreign_key: 'loan_id'
  belongs_to :owner, polymorphic: true
end
