# == Schema Information
#
# Table name: borrowers
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  middle_name      :string
#  suffix           :string
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
#  loan_id          :integer
#  user_id          :integer
#  dependent_count  :integer
#

class Borrower < ActiveRecord::Base
  belongs_to :user, inverse_of: :borrower, foreign_key: 'user_id'
  belongs_to :loan, inverse_of: :secondary_borrower, foreign_key: 'loan_id'

  has_one   :borrower_government_monitoring_info, inverse_of: :borrower, dependent: :destroy
  has_one   :credit_report, inverse_of: :borrower, dependent: :destroy

  has_many  :borrower_addresses, inverse_of: :borrower, dependent: :destroy
  has_many  :employments, inverse_of: :borrower, dependent: :destroy

  has_one  :first_bank_statement, inverse_of: :borrower, class_name: 'Documents::FirstBankStatement', dependent: :destroy, foreign_key: 'owner_id'
  has_one  :second_bank_statement, inverse_of: :borrower, class_name: 'Documents::SecondBankStatement', dependent: :destroy, foreign_key: 'owner_id'
  has_one  :first_paystub, inverse_of: :borrower, class_name: 'Documents::FirstPaystub', dependent: :destroy, foreign_key: 'owner_id'
  has_one  :second_paystub, inverse_of: :borrower, class_name: 'Documents::SecondPaystub', dependent: :destroy, foreign_key: 'owner_id'
  has_one  :first_w2, inverse_of: :borrower, class_name: 'Documents::FirstW2', dependent: :destroy, foreign_key: 'owner_id'
  has_one  :second_w2, inverse_of: :borrower, class_name: 'Documents::SecondW2', dependent: :destroy, foreign_key: 'owner_id'

  has_many :documents, dependent: :destroy, foreign_key: 'owner_id'

  accepts_nested_attributes_for :borrower_addresses, allow_destroy: true
  accepts_nested_attributes_for :employments, allow_destroy: true
  accepts_nested_attributes_for :borrower_government_monitoring_info, allow_destroy: true
  accepts_nested_attributes_for :credit_report, allow_destroy: true

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
    {dependent_ages: []},
    :gross_income,
    :gross_overtime,
    :gross_bonus,
    :gross_commission,
    borrower_addresses_attributes:                  [:id] + BorrowerAddress::PERMITTED_ATTRS,
    employments_attributes:                         [:id] + Employment::PERMITTED_ATTRS,
    borrower_government_monitoring_info_attributes: [:id] + BorrowerGovernmentMonitoringInfo::PERMITTED_ATTRS,
    credit_report_attributes:                       [:id] + CreditReport::PERMITTED_ATTRS
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

  def previous_addresses
    borrower_addresses.where(is_current: false)
  end

  def current_employment
    employments.find_by(is_current: true)
  end

  def previous_employments
    borrower_addresses.where(is_current: false)
  end

  def completed?
    first_name.present? && last_name.present? && dob.present? && ssn.present? && phone.present? &&
      years_in_school.present? && marital_status.present? && current_address.present? &&
      (dependent_count == 0 || (dependent_count > 0 && dependent_ages.count > 0))
  end

  def income_completed?
    gross_income.present? && gross_commission.present? && gross_bonus.present? &&
      gross_overtime.present? && current_employment.try(:completed?)
  end

end
