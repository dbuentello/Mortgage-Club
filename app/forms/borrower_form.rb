class BorrowerForm
  include ActiveModel::Model

  attr_accessor :address, :borrower_address, :borrower, :secondary_borrower, :params

  validate :validate_attributes

  def assign_value_to_attributes
    address.assign_attributes(address_params)
    borrower_address.assign_attributes(borrower_address_params)
    borrower.assign_attributes(borrower_params)
    secondary_borrower.assign_attributes(secondary_borrower_params) if params[:has_secondary_borrower] == "true"
  end

  def setup_associations
    borrower_address.address = address
    borrower.borrower_addresses << borrower_address
  end

  def save
    assign_value_to_attributes
    setup_associations

    return false unless valid?
    ActiveRecord::Base.transaction do
      borrower.save!
      secondary_borrower.save! if params[:has_secondary_borrower]
      address.save!
      borrower_address.save!
    end
  end

  def address
    @address ||= Address.new
  end

  def borrower_address
    @borrower_address ||= BorrowerAddress.new
  end

  def borrower
    @borrower ||= Borrower.new
  end

  def secondary_borrower
    @secondary_borrower ||= Borrower.new
  end

  private

  def validate_attributes
    add_errors(address.errors) if address.invalid?
    add_errors(borrower_address.errors) if borrower_address.invalid?
    add_errors(borrower.errors) if borrower.invalid?
  end

  def add_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def address_params
    ActionController::Parameters.new(params).require(:address).permit(Address::PERMITTED_ATTRS)
  end

  def borrower_address_params
    ActionController::Parameters.new(params).require(:borrower_address).permit(BorrowerAddress::PERMITTED_ATTRS)
  end

  def borrower_params
    ActionController::Parameters.new(params).require(:borrower).permit(Borrower::PERMITTED_ATTRS)
  end

  def secondary_borrower_params
    ActionController::Parameters.new(params).require(:secondary_borrower).permit(Borrower::PERMITTED_ATTRS)
  end
end