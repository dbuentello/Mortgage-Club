class BrokerageStatement < Document
  belongs_to :borrower, inverse_of: 'brokerage_statements', foreign_key: 'borrower_id'
end
