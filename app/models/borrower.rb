class Borrower < ActiveRecord::Base
  belongs_to :user, inverse_of: :borrower, foreign_key: 'user_id'
  belongs_to :loan, inverse_of: :secondary_borrower, foreign_key: 'loan_id'
  has_one   :borrower_government_monitoring_info, inverse_of: :borrower, dependent: :destroy
  has_many  :borrower_addresses, inverse_of: :borrower, dependent: :destroy
  has_many  :borrower_employers, inverse_of: :borrower, dependent: :destroy
  has_many  :bank_statements, inverse_of: :borrower, dependent: :destroy
  has_many  :brokerage_statements, inverse_of: :borrower, dependent: :destroy
  has_many  :paystubs, inverse_of: :borrower, dependent: :destroy
  has_many  :w2s, inverse_of: :borrower, dependent: :destroy
  accepts_nested_attributes_for :borrower_addresses, allow_destroy: true
  accepts_nested_attributes_for :borrower_employers, allow_destroy: true
  accepts_nested_attributes_for :borrower_government_monitoring_info, allow_destroy: true
  accepts_nested_attributes_for :bank_statements, allow_destroy: true
  accepts_nested_attributes_for :brokerage_statements, allow_destroy: true
  accepts_nested_attributes_for :paystubs, allow_destroy: true
  accepts_nested_attributes_for :w2s, allow_destroy: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  PERMITTED_ATTRS = [
    :first_name,
    :last_name,
    :middle_name,
    :suffix,
    :dob,
    :ssn,
    :phone,
    :years_in_school,
    :marital_status,
    :dependent_count,
    :dependent_ages,
    :gross_income,
    :gross_overtime,
    :gross_bonus,
    :gross_commission,
    borrower_addresses_attributes:                  [:id] + BorrowerAddress::PERMITTED_ATTRS,
    borrower_employers_attributes:                  [:id] + BorrowerEmployer::PERMITTED_ATTRS,
    borrower_government_monitoring_info_attributes: [:id] + BorrowerGovernmentMonitoringInfo::PERMITTED_ATTRS,
    bank_statements_attributes:                     [:id] + Document::PERMITTED_ATTRS,
    brokerage_statements_attributes:                [:id] + Document::PERMITTED_ATTRS,
    paystubs_attributes:                            [:id] + Document::PERMITTED_ATTRS,
    w2s_attributes:                                 [:id] + Document::PERMITTED_ATTRS
  ]

  enum marital_status: {
    married: 0,
    unmarried: 1,
    separated: 2
  }
end
