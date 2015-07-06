class Documents::FirstPaystub < Document
  belongs_to :borrower, inverse_of: :first_paystub, foreign_key: 'owner_id'
end
