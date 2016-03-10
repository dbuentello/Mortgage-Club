class PropertyForm
  include ActiveModel::Model

  attr_accessor :loan, :subject_property, :address, :params
  validate :validate_attributes

  def save
    assign_value_to_attributes
    setup_associations

    return false unless valid?

    ActiveRecord::Base.transaction do
      loan.save!
      subject_property.save!
      address.save!
      update_loan_amount
    end
    true
  end

  private

  def assign_value_to_attributes
    loan.assign_attributes(loan_params)
    subject_property.assign_attributes(subject_property_params)
    address.assign_attributes(address_params)
  end

  def setup_associations
    address.property = subject_property
    subject_property.loan = loan
  end

  def update_loan_amount
    loan.amount = CalculateLoanAmountService.call(loan)
    loan.save!
  end

  def loan_params
    if purchase_loan?
      params.require(:loan).permit(:purpose, :down_payment)
    elsif refinance_loan?
      params.require(:loan).permit(:purpose)
    end
  end

  def subject_property_params
    property_params = params.require(:subject_property).permit(Property::PERMITTED_ATTRS)

    if purchase_loan?
      property_params[:original_purchase_price] = property_params[:original_purchase_year] = nil
    elsif refinance_loan?
      property_params[:purchase_price] = nil
    end

    if primary_residence?
      property_params[:gross_rental_income] = nil
    end

    property_params
  end

  def address_params
    params.require(:address).permit(Address::PERMITTED_ATTRS)
  end

  def validate_attributes
    add_errors(address.errors) if address.invalid?
    add_errors(loan.errors) if loan.invalid?
    add_errors(subject_property.errors) if subject_property.invalid?
  end

  def add_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def refinance_loan?
    loan_purpose == "refinance"
  end

  def purchase_loan?
    loan_purpose == "purchase"
  end

  def primary_residence?
    params[:subject_property][:usage] == "primary_residence"
  end

  def loan_purpose
    return unless params[:loan]

    params[:loan][:purpose]
  end
end
