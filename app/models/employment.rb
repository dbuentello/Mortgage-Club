# == Schema Information
#
# Table name: employments
#
#  id                      :uuid             not null, primary key
#  borrower_id             :uuid
#  employer_name           :string
#  employer_contact_name   :string
#  employer_contact_number :string
#  job_title               :string
#  duration                :integer
#  is_current              :boolean
#

class Employment < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :employments, foreign_key: 'borrower_id', touch: true
  has_one :address, autosave: true, inverse_of: :employment
  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :borrower_id,
    :employer_name,
    :employer_contact_name,
    :employer_contact_number,
    :job_title,
    :duration,
    :is_current,
    :pay_frequency,
    :current_salary,
    :ytd_salary,
    :monthly_income,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  def completed?
    return false unless employer_name.present?
    return false unless address.present?
    return false unless employer_contact_name.present?
    return false unless employer_contact_number.present?
    return false unless current_salary.present?
    return false unless job_title.present?
    return false unless pay_frequency.present?
    return false unless duration.present?

    true
  end

  def previous_completed?
    return false unless employer_name.present?
    return false unless job_title.present?
    return false unless duration.present?
    return false unless monthly_income.present?

    true
  end

  def full_address
    return unless address

    address.full_text
  end

  def as_json(opts={})
    more_options = {
      include: :address
    }
    more_options.merge!(opts)

    super(more_options)
  end
end
