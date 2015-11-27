class SecondBusinessTaxReturn < BorrowerDocument
  DESCRIPTION = "Business tax return - Previous year"

  belongs_to :borrower, inverse_of: :second_business_tax_return, touch: true
  belongs_to :owner, polymorphic: true

  def label_name
    DESCRIPTION
  end
end
