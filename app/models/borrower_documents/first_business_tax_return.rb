class FirstBusinessTaxReturn < BorrowerDocument
  DESCRIPTION = "Business tax return - Most recent year"

  belongs_to :borrower, inverse_of: :first_business_tax_return, touch: true
  belongs_to :owner, polymorphic: true

  def label_name
    DESCRIPTION
  end
end
