class BorrowerForm
  include ActiveModel::Model

  attr_accessor :borrower, :secondary_borrower,
                :current_address, :current_borrower_address,
                :form_params

  validate :validate_attributes

  def save
    assign_value_to_attributes
    setup_associations
    return false unless valid?

    ActiveRecord::Base.transaction do
      borrower.save!
      current_address.save!
      current_borrower_address.save!
      create_primary_property unless current_borrower_address.is_rental

      if borrower.must_have_previous_address?
        previous_address.save!
        previous_borrower_address.save!
      elsif borrower.previous_address
        borrower.previous_address.destroy
      end
    end
    true
  end

  def assign_value_to_attributes
    current_address.assign_attributes(form_params[:current_address])
    current_borrower_address.assign_attributes(form_params[:current_borrower_address])
    borrower.assign_attributes(form_params[:borrower])
  end

  def setup_associations
    current_borrower_address.address = current_address
    borrower.borrower_addresses << current_borrower_address
  end

  def create_primary_property
    property = Property.find_or_initialize_by(is_primary: true, loan_id: form_params[:loan_id])
    property.address = current_address
    property.save!
  end

  def previous_address
    @previous_address ||= Address.new(form_params[:previous_address])
  end

  def current_borrower_address
    @current_borrower_address ||= BorrowerAddress.new
  end

  def current_address
    @current_address ||= Address.new
  end

  def previous_borrower_address
    @previous_borrower_address ||= begin
      borrower_address = BorrowerAddress.find_or_initialize_by(borrower: borrower, is_current: false)
      borrower_address.assign_attributes(form_params[:previous_borrower_address])
      borrower_address.address = previous_address
      borrower_address
    end
  end

  private

  def validate_attributes
    add_errors(address.errors) if current_address.invalid?
    add_errors(current_borrower_address.errors) if current_borrower_address.invalid?
    add_errors(borrower.errors) if borrower.invalid?
  end

  def add_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
