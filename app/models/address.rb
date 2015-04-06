class Address < ActiveRecord::Base
  belongs_to :property, inverse_of: :address, foreign_key: 'property_id'
  belongs_to :borrower_address, inverse_of: :address, foreign_key: 'borrower_address_id'
  belongs_to :borrower_employer, inverse_of: :address, foreign_key: 'borrower_employer_id'
  belongs_to :liability, inverse_of: :address, foreign_key: 'liability_id'

  PERMITTED_ATTRS = [
    :street_address,
    :street_address2,
    :city,
    :zip,
    :state,
    :property_id,
    :borrower_address_id,
    :borrower_employer_id,
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
end
