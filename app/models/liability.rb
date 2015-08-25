# == Schema Information
#
# Table name: liabilities
#
#  id               :uuid             not null, primary key
#  credit_report_id :uuid
#  name             :string
#  payment          :decimal(11, 2)
#  months           :integer
#  balance          :decimal(11, 2)
#  account_type     :string
#  phone            :string
#

class Liability < ActiveRecord::Base
  belongs_to :credit_report, inverse_of: :liabilities, foreign_key: 'credit_report_id'
  has_one :address, inverse_of: :liability, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  PERMITTED_ATTRS = [
    :name,
    # monthly payment
    :payment,
    # months remaining
    :months,
    # unpaid balance
    :balance,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]
end
