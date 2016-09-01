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

  def citizen_status_fnm
    case citizen_status
    when "C"
      "01"
    when "PR"
      "03"
    when "O"
      "05"
    else
      ""
    end
  end

  def fnm_values
    values = {}
    values[:gender_type] = gender_type
    values[:is_hispanic_or_latino] = is_hispanic_or_latino ? "1" : "2"
    values[:outstanding_judgment] = outstanding_judgment ? "Y" : "N"
    values[:bankrupt] = bankrupt ? "Y" : "N"
    values[:loan_foreclosure] = loan_foreclosure ? "Y" : "N"
    values[:party_to_lawsuit] = party_to_lawsuit ? "Y" : "N"
    values[:present_delinquent_loan] = present_delinquent_loan ? "Y" : "N"
    values[:down_payment_borrowed] = down_payment_borrowed ? "Y" : "N"
    values[:citizen_status] = citizen_status_fnm
    values[:ownership_interest] = ownership_interest ? "Y" : "N"
    values[:co_maker_or_endorser] = co_maker_or_endorser ? "Y" : "N"

    values
  end
end
