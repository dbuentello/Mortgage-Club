class W2 < Document
  belongs_to :borrower, inverse_of: 'w2s', foreign_key: 'borrower_id'
end
