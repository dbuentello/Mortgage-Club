class Documents::FirstBrokerageStatement < Document
  belongs_to :borrower, inverse_of: :first_brokerage_statement, foreign_key: 'owner_id'
end