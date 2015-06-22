class Documents::FirstBankStatement < Document
  belongs_to :borrower, inverse_of: :first_bank_statement, foreign_key: 'borrower_id'
end