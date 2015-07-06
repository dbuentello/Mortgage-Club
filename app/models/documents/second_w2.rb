class Documents::SecondW2 < Document
  belongs_to :borrower, inverse_of: :second_w2, foreign_key: 'owner_id'
end
