class W2 < Document
  belongs_to :borrower, foreign_key: 'borrower_id'
end
