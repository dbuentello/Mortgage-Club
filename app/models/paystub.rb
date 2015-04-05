class Paystub < Document
  belongs_to :borrower, inverse_of: 'paystubs', foreign_key: 'borrower_id'
end
