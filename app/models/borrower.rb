# == Schema Information
#
# Table name: borrowers
#
#  id               :uuid             not null, primary key
#  dob              :datetime
#  ssn              :binary
#  phone            :string
#  years_in_school  :integer
#  marital_status   :integer
#  dependent_ages   :integer          default([]), is an Array
#  gross_income     :decimal(13, 2)
#  gross_overtime   :decimal(11, 2)
#  gross_bonus      :decimal(11, 2)
#  gross_commission :decimal(11, 2)
#  loan_id          :uuid
#  user_id          :uuid
#  dependent_count  :integer
#

class Borrower < ActiveRecord::Base
  belongs_to :user, inverse_of: :borrower, foreign_key: 'user_id', autosave: true
  belongs_to :loan, inverse_of: :secondary_borrower, foreign_key: 'loan_id'

  has_one   :borrower_government_monitoring_info, inverse_of: :borrower, dependent: :destroy
  has_one   :credit_report, inverse_of: :borrower, dependent: :destroy

  has_many  :borrower_addresses, inverse_of: :borrower, dependent: :destroy
  has_many  :employments, inverse_of: :borrower, dependent: :destroy

  has_one  :first_bank_statement, inverse_of: :borrower, dependent: :destroy
  has_one  :second_bank_statement, inverse_of: :borrower, dependent: :destroy
  has_one  :first_paystub, inverse_of: :borrower, dependent: :destroy
  has_one  :second_paystub, inverse_of: :borrower, dependent: :destroy
  has_one  :first_w2, inverse_of: :borrower, dependent: :destroy
  has_one  :second_w2, inverse_of: :borrower, dependent: :destroy
  has_one  :first_personal_tax_return, inverse_of: :borrower, dependent: :destroy
  has_one  :second_personal_tax_return, inverse_of: :borrower, dependent: :destroy
  has_one  :first_business_tax_return, inverse_of: :borrower, dependent: :destroy
  has_one  :second_business_tax_return, inverse_of: :borrower, dependent: :destroy
  has_one  :first_federal_tax_return, inverse_of: :borrower, dependent: :destroy
  has_one  :second_federal_tax_return, inverse_of: :borrower, dependent: :destroy
  has_one  :ocr, inverse_of: :borrower, dependent: :destroy

  has_many :other_borrower_reports, inverse_of: :borrower, dependent: :destroy
  has_many :borrower_documents, dependent: :destroy

  has_one  :declaration

  accepts_nested_attributes_for :borrower_addresses, allow_destroy: true
  accepts_nested_attributes_for :employments, allow_destroy: true
  accepts_nested_attributes_for :borrower_government_monitoring_info, allow_destroy: true
  accepts_nested_attributes_for :credit_report, allow_destroy: true
  accepts_nested_attributes_for :declaration, allow_destroy: true

  delegate :first_name, :first_name=, to: :user, allow_nil: true
  delegate :last_name, :last_name=, to: :user, allow_nil: true
  delegate :middle_name, :middle_name=, to: :user, allow_nil: true
  delegate :suffix, :suffix=, to: :user, allow_nil: true

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
    {dependent_ages: []},
    :gross_income,
    :gross_overtime,
    :gross_bonus,
    :gross_commission,
    :self_employed,
    employments_attributes:                         [:id] + Employment::PERMITTED_ATTRS,
    borrower_government_monitoring_info_attributes: [:id] + BorrowerGovernmentMonitoringInfo::PERMITTED_ATTRS,
    credit_report_attributes:                       [:id] + CreditReport::PERMITTED_ATTRS,
    declaration_attributes:                         [:id] + Declaration::PERMITTED_ATTRS
  ]

  enum marital_status: {
    married: 0,
    unmarried: 1,
    separated: 2
  }

  def current_address
    borrower_addresses.find_by(is_current: true)
  end

  def display_current_address
    current_address.try(:address).try(:address) || 'No Address'
  end

  def previous_address
    borrower_addresses.find_by(is_current: false)
  end

  def must_have_previous_address?
    current_address && current_address.years_at_address.to_f <= 1
  end

  def current_employment
    @current_employment ||= employments.find_by(is_current: true)
  end

  def previous_employments
    employments.where(is_current: false)
  end

  def completed?
    first_name.present? && last_name.present? &&
    ssn.present? && dob.present? && phone.present? &&
      years_in_school.present? && marital_status.present? && current_address.present? &&
      (dependent_count == 0 || (dependent_count > 0 && dependent_ages.count > 0))
  end

  def documents_completed?
    first_w2.present? && second_w2.present? &&
      first_paystub.present? && second_paystub.present? &&
      first_bank_statement.present? && second_bank_statement.present?
  end

  def income_completed?
      current_employment.try(:completed?)
  end

  def credit_score
    credit_report.score
  end

  def current_salary
    current_employment.present? ? current_employment.current_salary.to_f : 0
  end
end
