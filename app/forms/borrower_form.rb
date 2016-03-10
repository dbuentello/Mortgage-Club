class BorrowerForm
  include ActiveModel::Model

  attr_accessor :borrower, :loan, :form_params, :is_primary_borrower

  validate :validate_attributes

  def save
    assign_value_to_attributes
    setup_associations
    return false unless valid?

    ActiveRecord::Base.transaction do
      borrower.save!
      current_address.save!
      current_borrower_address.save!
      update_primary_property if primary_borrower?

      if borrower.must_have_previous_address?
        update_old_address
      else
        borrower.previous_address.destroy if borrower.previous_address
      end
    end
    true
  end

  private

  def assign_value_to_attributes
    current_address.assign_attributes(form_params[:current_address])
    current_borrower_address.assign_attributes(form_params[:current_borrower_address])
    borrower.assign_attributes(form_params[:borrower])
  end

  def setup_associations
    current_borrower_address.address = current_address
    borrower.borrower_addresses << current_borrower_address
  end

  def update_primary_property
    if borrower_rents_house?
      unset_primary_property
    else
      create_primary_property
    end
  end

  def create_primary_property
    return if loan.primary_property.present?
    subject_property = loan.subject_property
    return subject_property.update(is_primary: true) if subject_property.primary_residence?

    if loan.refinance? && borrower_and_subject_property_same_address?
      Property.create(loan: loan, is_primary: true, usage: "primary_residence",
        property_type: subject_property.property_type, market_price: subject_property.market_price,
        mortgage_includes_escrows: subject_property.mortgage_includes_escrows,
        estimated_property_tax: subject_property.estimated_property_tax,
        estimated_hazard_insurance: subject_property.estimated_hazard_insurance)
    else
      Property.create(loan: loan, is_primary: true, usage: "primary_residence")
    end
  end

  def unset_primary_property
    loan.primary_property.destroy if loan.primary_property
  end

  def update_old_address
    previous_borrower_address.save!
    previous_address.save!
  end

  def primary_borrower?
    is_primary_borrower
  end

  def borrower_rents_house?
    current_borrower_address.is_rental
  end

  def borrower_and_subject_property_same_address?
    subject_property_address = loan.subject_property.address

    return true if current_address.city == subject_property_address.city &&
                  current_address.state == subject_property_address.state &&
                  current_address.street_address == subject_property_address.street_address &&
                  current_address.street_address2 == subject_property_address.street_address2 &&
                  current_address.zip == subject_property_address.zip

    false
  end

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

  def current_borrower_address
    @current_borrower_address ||= borrower.current_address || BorrowerAddress.new
  end

  def current_address
    @current_address ||= begin
      borrower.current_address.present? ? borrower.current_address.address : Address.new
    end
  end

  def previous_address
    @previous_address ||= Address.new(form_params[:previous_address])
  end

  def previous_borrower_address
    @previous_borrower_address ||= begin
      borrower_address = BorrowerAddress.find_or_initialize_by(borrower: borrower, is_current: false)
      borrower_address.assign_attributes(form_params[:previous_borrower_address])
      borrower_address.address = previous_address
      borrower_address
    end
  end
end
