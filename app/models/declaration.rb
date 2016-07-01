# == Schema Information
#
# Table name: declarations
#
#  id                       :uuid             not null, primary key
#  outstanding_judgment     :boolean
#  bankrupt                 :boolean
#  property_foreclosed      :boolean
#  party_to_lawsuit         :boolean
#  loan_foreclosure         :boolean
#  nil_deliquent_loan       :boolean
#  child_support            :boolean
#  down_payment_borrowed    :boolean
#  co_maker_or_endorser     :boolean
#  citizen_status           :string
#  is_hispanic_or_latino    :string
#  gender_type              :string
#  race_type                :string
#  ownership_interest       :boolean
#  type_of_property         :string
#  title_of_property        :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  borrower_id              :uuid
#

class Declaration < ActiveRecord::Base
  belongs_to :borrower

  validates :borrower_id, presence: true

  PERMITTED_ATTRS = [
    :outstanding_judgment,
    :bankrupt,
    :property_foreclosed,
    :party_to_lawsuit,
    :loan_foreclosure,
    :present_delinquent_loan,
    :child_support,
    :down_payment_borrowed,
    :co_maker_or_endorser,
    :citizen_status,
    :is_hispanic_or_latino,
    :gender_type,
    :race_type,
    :ownership_interest,
    :type_of_property,
    :title_of_property
  ]

  def completed?
    !(citizen_status.nil? && ownership_interest.nil? &&
    is_hispanic_or_latino.nil? && gender_type.nil? && race_type.nil?
    type_of_property.nil? && title_of_property.nil?)
  end
end
