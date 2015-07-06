class CreditReport < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :credit_report, foreign_key: 'owner_id'
  has_many  :liabilities, inverse_of: :credit_report, dependent: :destroy
  accepts_nested_attributes_for :liabilities, allow_destroy: true

  PERMITTED_ATTRS = [
    :date,
    :score,
    liabilities_attributes: [:id] + Liability::PERMITTED_ATTRS
  ]
end
