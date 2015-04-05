class BankStatement < Document
  belongs_to :borrower, inverse_of: 'bank_statements', foreign_key: 'borrower_id'
end
