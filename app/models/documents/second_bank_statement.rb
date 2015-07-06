class Documents::SecondBankStatement < Document
  belongs_to :borrower, inverse_of: :second_bank_statement, foreign_key: 'owner_id'
end