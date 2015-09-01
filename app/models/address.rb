# == Schema Information
#
# Table name: addresses
#
#  id                  :uuid             not null, primary key
#  street_address      :string
#  street_address2     :string
#  zip                 :string
#  state               :text
#  property_id         :uuid
#  borrower_address_id :uuid
#  employment_id       :uuid
#  city                :text
#  full_text           :text
#  liability_id        :uuid
#

class Address < ActiveRecord::Base
  belongs_to :property, inverse_of: :address, foreign_key: 'property_id'
  belongs_to :borrower_address, inverse_of: :address, foreign_key: 'borrower_address_id', touch: true
  belongs_to :employment, inverse_of: :address, foreign_key: 'employment_id'
  belongs_to :liability, inverse_of: :address, foreign_key: 'liability_id'

  after_save :assign_loan_to_billy

  PERMITTED_ATTRS = [
    :street_address,
    :street_address2,
    :city,
    :zip,
    :state,
    :property_id,
    :borrower_address_id,
    :employment_id,
    :full_text
  ]

  def address
    components = [
      street_address,
      street_address2,
      city,
      state,
      zip
    ].compact.reject{|x| x.blank?}

    if components.empty?
      full_text
    else
      components.join(', ')
    end
  end

  def completed
    address.present?
  end

  private

  def assign_loan_to_billy
    return if state != 'CA'
    return unless property && property.loan.present?
    return unless user = User.where(email: 'billy@mortgageclub.io').last
    user.loan_member.loans_members_associations.create(loan_id: property.loan.id)
  end
end
