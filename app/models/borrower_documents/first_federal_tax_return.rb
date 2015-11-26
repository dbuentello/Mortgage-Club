class FirstFederalTaxReturn < BorrowerDocument
  DESCRIPTION = "Federal tax return - Most recent year"

  belongs_to :borrower, inverse_of: :first_federal_tax_return, touch: true
  belongs_to :owner, polymorphic: true

  def label_name
    DESCRIPTION
  end
end
