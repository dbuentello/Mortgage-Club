class W2 < Document
  belongs_to :borrower, inverse_of: 'w2_documents', foreign_key: 'borrower_id'
end
