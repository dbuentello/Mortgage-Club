class Documents::FirstW2 < Document
  belongs_to :borrower, inverse_of: :first_w2, foreign_key: 'owner_id'
end
