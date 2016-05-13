class UpdateLoanTermsService
  attr_reader :loan, :property, :address, :params

  def initialize(loan, params)
    @loan = loan
    @property = loan.subject_property
    @address = property.address
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      update_loan
      update_property
      update_address
    end
  end

  def update_loan
    loan.amount = params[:loan_amount]
    loan.amortization_type = params[:loan_type]
    loan.interest_rate = params[:interest_rate]
    loan.lender_credits = params[:lender_credits]
    loan.loan_costs = params[:lender_fees]
    loan.third_party_fees = params[:third_party_services]
    loan.estimated_prepaid_items = params[:prepaid_items]
    loan.down_payment = params[:down_payment]
    loan.estimated_cash_to_close = params[:total_cash_to_close]
    loan.monthly_payment = params[:principal_interest]

    loan.save!
  end

  def update_property
    property.estimated_hazard_insurance = params[:homeowners_insurance]
    property.estimated_property_tax = params[:property_tax]
    property.hoa_due = params[:hoa_due]
    property.estimated_mortgage_insurance = params[:mortgage_insurance]
    if loan.purchase?
      property.purchase_price = params[:property_value]
    else
      property.market_price = params[:property_value]
    end

    property.save!
  end

  def update_address
    address.assign_attributes(address_params)
    address.save!
  end

  private

  def address_params
    params.require(:address).permit(Address::PERMITTED_ATTRS)
  end
end
