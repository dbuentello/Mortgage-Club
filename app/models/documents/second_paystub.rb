class Documents::SecondPaystub < Document
  belongs_to :borrower, inverse_of: :second_paystub, foreign_key: 'borrower_id'
end
