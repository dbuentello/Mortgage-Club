class Documents::SecondPaystub < Document
  belongs_to :borrower, inverse_of: :second_paystub, foreign_key: 'owner_id'
end
