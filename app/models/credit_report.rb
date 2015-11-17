# == Schema Information
#
# Table name: credit_reports
#
#  id          :uuid             not null, primary key
#  borrower_id :uuid
#  date        :datetime
#  score       :integer
#

class CreditReport < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :credit_report, foreign_key: 'borrower_id'
  has_many :liabilities, inverse_of: :credit_report, dependent: :destroy
  accepts_nested_attributes_for :liabilities, allow_destroy: true

  PERMITTED_ATTRS = [
    :date,
    :score,
    liabilities_attributes: [:id] + Liability::PERMITTED_ATTRS
  ]

  def sum_liability_payment
    liabilities.sum(:payment)
  end
end
