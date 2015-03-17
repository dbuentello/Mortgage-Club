class Borrower < ActiveRecord::Base
  has_many  :borrower_addresses, dependent: :destroy
  has_many  :borrower_employers, dependent: :destroy
  has_one   :borrower_government_monitoring_info, dependent: :destroy
  accepts_nested_attributes_for :borrower_addresses, allow_destroy: true
  accepts_nested_attributes_for :borrower_employers, allow_destroy: true
  accepts_nested_attributes_for :borrower_government_monitoring_info, allow_destroy: true

  PERMITTED_ATTRS = [
    :first_name,
    :last_name,
    :middle_name,
    :suffix,
    :date_of_birth,
    :social_security_number,
    :phone_number,
    :years_in_school,
    :marital_status_type,
    :ages_of_dependents,
    :gross_income,
    :gross_overtime,
    :gross_bonus,
    :gross_commission,
    borrower_addresses_attributes:                  [:id] + BorrowerAddress::PERMITTED_ATTRS,
    borrower_employers_attributes:                  [:id] + BorrowerEmployers::PERMITTED_ATTRS,
    borrower_government_monitoring_info_attributes: [:id] + GovernmentMonitoringInfo::PERMITTED_ATTRS
  ]

  enum marital_status_type: {
    married: 0,
    unmarried: 1,
    separated: 2
  }
end