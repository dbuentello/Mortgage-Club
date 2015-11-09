# == Schema Information
#
# Table name: properties
#
#  id                         :uuid             not null, primary key
#  property_type              :integer
#  usage                      :integer
#  original_purchase_year     :integer
#  original_purchase_price    :decimal(13, 2)
#  purchase_price             :decimal(13, 2)
#  market_price               :decimal(13, 2)
#  gross_rental_income        :decimal(11, 2)
#  estimated_property_tax     :decimal(11, 2)
#  estimated_hazard_insurance :decimal(11, 2)
#  is_impound_account         :boolean
#  loan_id                    :uuid
#

class Property < ActiveRecord::Base
  belongs_to :loan, foreign_key: 'loan_id'

  has_one :address, autosave: true, inverse_of: :property

  has_one :appraisal_report, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :homeowners_insurance, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :mortgage_statement, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :lease_agreement, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :purchase_agreement, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :flood_zone_certification, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :termite_report, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :inspection_report, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :title_report, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_one :risk_report, inverse_of: :property, dependent: :destroy, foreign_key: 'property_id'
  has_many :other_property_reports, dependent: :destroy, foreign_key: 'property_id'
  has_many :property_documents, dependent: :destroy, foreign_key: 'property_id'
  has_many :liabilities, dependent: :destroy, foreign_key: 'property_id'

  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :property_type,
    :usage,
    :original_purchase_year,
    :original_purchase_price,
    :purchase_price,
    :gross_rental_income,
    :market_price,
    :estimated_property_tax,
    :estimated_hazard_insurance,
    :estimated_mortgage_insurance,
    :mortgage_includes_escrows,
    :is_impound_account,
    :hoa_due,
    :is_primary,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  enum property_type: {
    sfh: 0,
    duplex: 1,
    triplex: 2,
    fourplex: 3,
    condo: 4
  }

  enum usage: {
    primary_residence: 0,
    vacation_home: 1,
    rental_property: 2
  }

  enum mortgage_includes_escrows: {
    taxes_and_insurance: 0,
    taxes_only: 1,
    no: 2,
    not_sure: 3
  }

  validates_associated :address
  validate :do_not_have_more_than_two_liabilities

  def mortgage_payment_liability
    liabilities.where(account_type: "Mortgage").last
  end

  def other_financing_liability
    liabilities.where.not(account_type: "Mortgage").last
  end

  def usage_name
    return unless usage
    usage.split('_').map(&:capitalize).join(' ')
  end

  def completed?
    property_type.present? && usage.present? && address.present?
  end

  def refinance_completed?
    original_purchase_price.present? && original_purchase_year.present?
  end

  def actual_rental_income
    gross_rental_income.to_f * 0.75
  end

  def liability_payments
    liabilities.sum(:payment)
  end

  def mortgage_payment
    liability = liabilities.where(account_type: 'Mortgage').last
    liability.present? ? liability.payment.to_f : 0
  end

  def other_financing
    liability = liabilities.where(account_type: 'OtherFinancing').last
    liability.present? ? liability.payment.to_f : 0
  end

  private

  def do_not_have_more_than_two_liabilities
    errors.add(:liabilities, "can't have more than two liabilities") if liabilities.count > 2
  end
end
