class Documents::SecondBrokerageStatement < Document
  belongs_to :borrower, inverse_of: :second_brokerage_statement, foreign_key: 'borrower_id'
end