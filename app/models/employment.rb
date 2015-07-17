# == Schema Information
#
# Table name: employments
#
#  id                      :integer          not null, primary key
#  borrower_id             :integer
#  employer_name           :string
#  employer_contact_name   :string
#  employer_contact_number :string
#  job_title               :string
#  duration                :integer
#  is_current              :boolean
#

class Employment < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :employments, foreign_key: 'borrower_id'
  has_one :address, inverse_of: :employment
  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :borrower_id,
    :employer_name,
    :employer_contact_name,
    :employer_contact_number,
    :job_title,
    :duration,
    :is_current,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  def completed?
    employer_name.present? && address.present? && employer_contact_name.present? && employer_contact_number.present?
  end

  def as_json(opts={})
    more_options = {
      :include => { :address => {} }
    }

    options = super(opts)
    options.merge!(more_options)

    options
  end
end
