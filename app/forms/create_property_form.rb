class CreatePropertyForm
  include ActiveModel::Model

  attr_accessor :loan_id, :properties, :credit_report_id

  def initialize(loan_id, primary_property, rental_properties, credit_report_id)
    @loan_id = loan_id
    @primary_property = primary_property
    @rental_properties = rental_properties
    @credit_report_id = credit_report_id
  end

  validates :loan_id, :properties, presence: true

  def save
    ActiveRecord::Base.transaction do
      loan = Loan.find_by_id(@loan_id)
      if @rental_properties.present?
        i = 0
        @rental_properties.each do |property|
          rental_params = property[1]
          property_attributes = property_params(property[1])
          if i < loan.rental_properties.size
            property = loan.rental_properties[i]
            property.update(property_attributes)
          else
            property = Property.new(property_attributes)
            property.loan_id = @loan_id
            property.save
          end
          i += 1

          # TODO: refactor them
          property.liabilities.update_all(property_id: nil)
          handle_liability(rental_params[:mortgagePayment], property, "Mortgage", rental_params)
          handle_liability(rental_params[:otherFinancing], property, "OtherFinancing", rental_params)
          update_mortgage_payment(property)
        end
      end

      loan.primary_property.update(property_params(@primary_property))
      loan.primary_property.liabilities.update_all(property_id: nil)
      handle_liability(@primary_property[:mortgagePayment], loan.primary_property, "Mortgage", @primary_property)
      handle_liability(@primary_property[:otherFinancing], loan.primary_property, "OtherFinancing", @primary_property)
      update_mortgage_payment(loan.primary_property)
    end
    true
  end

  def handle_liability(liability_id, property, account_type, params)
    if liability_id != "Mortgage" && liability_id != "OtherFinancing"
      link_liability_to_property(property.id, liability_id, account_type)
    else
      payment = (liability_id == "Mortgage") ? params[:other_mortgage_payment_amount] : params[:other_financing_amount]
      liability = create_liability(payment, account_type)
      link_liability_to_property(property.id, liability.id, account_type)
    end
  end

  def update_mortgage_payment(property)
    return unless property.mortgage_payment_liability

    mortgage_payment = property.mortgage_payment_liability.payment.to_f
    case property.mortgage_includes_escrows
    when "taxes_and_insurance"
      mortgage_payment = mortgage_payment - property.estimated_property_tax.to_f - property.estimated_hazard_insurance.to_f
    when "taxes_only"
      mortgage_payment = mortgage_payment - property.estimated_property_tax.to_f
    when "no"
      mortgage_payment = mortgage_payment - property.estimated_hazard_insurance.to_f
    end
    property.update(mortgage_payment: mortgage_payment)
  end

  private

  def link_liability_to_property(property_id, liability_id, account_type = nil)
    return unless liability = Liability.find_by_id(liability_id)

    liability.update(
      property_id: property_id,
      account_type: account_type.present? ? account_type : liability.account_type
    )
  end

  def create_liability(payment, account_type)
    Liability.create(
      payment: payment,
      account_type: account_type,
      credit_report_id: credit_report_id,
      user_input: true
    )
  end

  def property_params(params)
    params.permit(Property::PERMITTED_ATTRS)
  end

end