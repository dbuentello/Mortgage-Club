class CreatePropertyForm
  include ActiveModel::Model

  attr_accessor :loan, :primary_property, :subject_property,
                :credit_report_id, :primary_property_params,
                :subject_property_params, :rental_properties_params,
                :borrower_address

  def initialize(args)
    @loan = Loan.find_by_id(args[:loan_id])
    @primary_property = loan.primary_property
    @subject_property = loan.subject_property
    @primary_property_params = args[:primary_property].except(:address_attributes)
    @subject_property_params = args[:subject_property]
    @rental_properties_params = args[:rental_properties] || []
    @credit_report_id = args[:credit_report_id]
    @borrower_address = args[:borrower_address]
  end

  # validates :loan_id, :properties, presence: true
  def save
    return false if loan.nil?

    ActiveRecord::Base.transaction do
      update_rental_properties
      update_subject_property
      update_primary_property
      update_borrower_address
    end

    true
  end

  def update_rental_properties
    rental_properties_params.each do |_, params|
      if new_property?(params)
        property = Property.new(property_params(params))
        property.loan_id = loan.id
        property.save
      else
        property = Property.find(params[:id])
        property.update(property_params(params))
      end
      # property.update_mortgage_payment_amount
      update_liabilities(property, params)
    end
  end

  def update_subject_property
    return unless subject_property

    subject_property.update(property_params(subject_property_params))
    # subject_property.update_mortgage_payment_amount
    update_liabilities(subject_property, subject_property_params)
  end

  def update_primary_property
    return unless primary_property
    primary_property.update(property_params(primary_property_params))

    primary_property.address.destroy if primary_property.address
    # primary_property.update_mortgage_payment_amount
    update_liabilities(primary_property, primary_property_params)
  end

  def update_borrower_address
    return unless borrower_address
    return unless borrower_address[:cached_address]

    address = BorrowerAddress.find(borrower_address[:id]).address
    address.update(
      street_address: borrower_address[:cached_address][:street_address],
      street_address2: borrower_address[:cached_address][:street_address2],
      zip: borrower_address[:cached_address][:zip],
      state: borrower_address[:cached_address][:state],
      city: borrower_address[:cached_address][:city],
      full_text: borrower_address[:cached_address][:full_text]
    )
  end

  def update_liabilities(property, params)
    property.liabilities.update_all(property_id: nil)
    return if property_does_not_have_any_liabilities?(params)

    if new_mortgage_payment_liability?(params) || new_other_financing_liability?(params)
      liability = create_other_liability(params)
    else
      liability_id = params[:mortgagePayment].present? ? params[:mortgagePayment] : params[:otherFinancing]
      liability = Liability.find(liability_id)
    end
    link_liability_to_property(property.id, liability, "Mortgage")
  end

  def create_other_liability(params)
    if new_mortgage_payment_liability?(params)
      payment_amount = params[:other_mortgage_payment_amount]
      account_type = "Mortgage"
    else
      payment_amount = params[:other_financing_amount]
      account_type = "OtherFinancing"
    end

    Liability.create(
      payment: payment_amount,
      account_type: account_type,
      credit_report_id: credit_report_id,
      user_input: true
    )
  end

  def link_liability_to_property(property_id, liability, account_type = nil)
    liability.update(
      property_id: property_id,
      account_type: account_type.present? ? account_type : liability.account_type
    )
  end

  private

  def property_does_not_have_any_liabilities?(params)
    params[:mortgagePayment].blank? && params[:otherFinancing].blank?
  end

  def new_property?(property_attributes)
    property_attributes[:id].nil?
  end

  def new_mortgage_payment_liability?(property_attributes)
    property_attributes[:mortgagePayment] == "Mortgage"
  end

  def new_other_financing_liability?(property_attributes)
    property_attributes[:otherFinancing] == "OtherFinancing"
  end

  def property_params(params)
    params.permit(Property::PERMITTED_ATTRS)
  end
end
