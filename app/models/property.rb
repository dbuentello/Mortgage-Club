# == Schema Information
#
# Table name: properties
#
#  id                         :integer          not null, primary key
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
#  loan_id                    :integer
#

class Property < ActiveRecord::Base
  belongs_to :loan, inverse_of: :property, foreign_key: 'loan_id'

  has_one :address, inverse_of: :property

  has_one :appraisal_report, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :homeowners_insurance, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :mortgage_statement, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :lease_agreement, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :purchase_agreement, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :flood_zone_certification, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :termite_report, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :inspection_report, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :title_report, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'
  has_one :risk_report, inverse_of: :property, dependent: :destroy, foreign_key: 'owner_id'

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
    :is_impound_account,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  enum property_type: {
    sfh: 0,
    duplex: 1,
    triplex: 2,
    quadruplex: 3
  }

  enum usage: {
    primary_residence: 0,
    vacation_home: 1,
    rental_property: 2
  }

  def usage_name
    usage.split('_').map(&:capitalize).join(' ')
  end
end
