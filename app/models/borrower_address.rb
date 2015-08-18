# == Schema Information
#
# Table name: borrower_addresses
#
#  id               :uuid             not null, primary key
#  borrower_id      :uuid
#  years_at_address :integer
#  is_rental        :boolean
#  is_current       :boolean          default(FALSE), not null
#

class BorrowerAddress < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :borrower_addresses, foreign_key: 'borrower_id'
  has_one :address, inverse_of: :borrower_address, dependent: :destroy
  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :borrower_id,
    :years_at_address,
    :is_rental,
    :is_current,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  def as_json(opts={})
    more_options = {
      include: :address
    }
    more_options.merge!(opts)

    super(more_options)
  end
end
