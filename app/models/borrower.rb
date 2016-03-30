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
  has_one :borrower_government_monitoring_info, inverse_of: :borrower, dependent: :destroy
  has_one :credit_report, inverse_of: :borrower, dependent: :destroy
  has_one :ocr, inverse_of: :borrower, dependent: :destroy
  has_one :declaration, dependent: :destroy
  has_many :borrower_addresses, inverse_of: :borrower, dependent: :destroy
  has_many :employments, inverse_of: :borrower, dependent: :destroy
  has_many :documents, as: :subjectable, dependent: :destroy
  has_many :assets, dependent: :destroy

  accepts_nested_attributes_for :borrower_addresses, allow_destroy: true
  accepts_nested_attributes_for :employments, allow_destroy: true
  accepts_nested_attributes_for :borrower_government_monitoring_info, allow_destroy: true
  accepts_nested_attributes_for :credit_report, allow_destroy: true
  accepts_nested_attributes_for :declaration, allow_destroy: true

  delegate :first_name, :first_name=, to: :user, allow_nil: true
  delegate :last_name, :last_name=, to: :user, allow_nil: true
  delegate :middle_name, :middle_name=, to: :user, allow_nil: true
  delegate :full_name, to: :user
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
    :gross_interest,
    :self_employed,
    :is_file_taxes_jointly,
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
    return unless must_have_previous_address?

    borrower_addresses.find_by(is_current: false)
  end

  def must_have_previous_address?
    current_address && current_address.years_at_address.to_f < 2
  end

  def display_previous_address
    previous_address.try(:address).try(:address) || 'No Address'
  end

  def current_employment
    @current_employment ||= employments.find_by(is_current: true)
  end

  def previous_employment
    return unless must_have_previous_employment?

    employments.find_by(is_current: false)
  end

  def must_have_previous_employment?
    current_employment && current_employment.duration.to_f < 2
  end

  def completed?
    return false if self_employed.nil?
    return false unless first_name.present?
    return false unless last_name.present?
    return false unless ssn.present?
    return false unless dob.present?
    return false unless years_in_school.present?
    return false unless marital_status.present?
    return false unless dependent_count
    return false if dependent_count > 0 && dependent_ages.blank?
    return false unless current_address
    return false if current_address.is_rental.nil?
    return false unless current_address.years_at_address
    return false if current_address.years_at_address < 0

    if current_address.is_rental
      return false unless current_address.monthly_rent
    end
    return false unless previous_address_completed?

    true
  end

  def previous_address_completed?
    if previous_address.present?
      return false if previous_address.is_rental.nil?
      return false unless previous_address.monthly_rent
    end

    true
  end

  def other_documents
    documents.where(document_type: "other_borrower_report")
  end

  def documents_completed?
    if self_employed
      required_documents = %w(first_personal_tax_return second_personal_tax_return
                              first_business_tax_return second_business_tax_return
                              first_bank_statement second_bank_statement)
    else
      required_documents = %w(first_w2 second_w2 first_paystub second_paystub
                              first_federal_tax_return second_federal_tax_return
                              first_bank_statement second_bank_statement)
    end

    (required_documents - documents.pluck(:document_type)).empty?
  end

  def secondary_borrower_documents_completed?
    if self_employed
      if is_file_taxes_jointly
        required_documents = %w(first_business_tax_return second_business_tax_return first_bank_statement second_bank_statement)
      else
        required_documents = %w(first_personal_tax_return second_personal_tax_return first_business_tax_return second_business_tax_return first_bank_statement second_bank_statement)
      end
      return (required_documents - documents.pluck(:document_type)).empty?
    else
      if is_file_taxes_jointly
        required_documents = %w(first_w2 second_w2 first_paystub second_paystub  first_bank_statement second_bank_statement)
      else
        required_documents = %w(first_w2 second_w2 first_paystub second_paystub first_federal_tax_return second_federal_tax_return  first_bank_statement second_bank_statement)
      end
      return (required_documents - documents.pluck(:document_type)).empty?
    end
  end

  def income_completed?
    return false unless current_employment.try(:completed?)
    return false unless current_employment.duration >= 2 || (current_employment.duration < 2 && previous_employment.previous_completed?)
    return false unless gross_income

    true
  end

  def credit_score
    return 0 unless credit_report

    credit_report.score
  end

  def current_salary
    current_employment.present? ? current_employment.current_salary.to_f : 0
  end

  def total_income
    current_salary + gross_overtime.to_f + gross_bonus.to_f + gross_commission.to_f + gross_interest.to_f
  end

  def annual_income
    return 0 unless current_employment.present? && current_employment.current_salary.present?
    (current_employment.current_salary * 12).round
  end
end
