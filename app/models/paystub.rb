class Paystub < Document
  belongs_to :borrower, foreign_key: 'borrower_id'
end
