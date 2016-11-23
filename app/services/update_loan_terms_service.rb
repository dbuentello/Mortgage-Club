#
# Class UpdateLoanTermsService provides features to help loan member update terms of loan
# Edit Loan Page
# @author Tang Nguyen <tang@mortgageclub.co>
#
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
      update_property
      update_loan
      update_loan_fees
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
    loan.is_rate_locked = params[:is_rate_locked]
    loan.rate_lock_expiration_date = params[:rate_lock_expiration_date]
    loan.closing_date = params[:closing_date]

    loan.save!
  end

  def update_loan_fees
    loan.lender_underwriting_fee = params[:lender_underwriting_fee]
    loan.appraisal_fee = params[:appraisal_fee]
    loan.tax_certification_fee = params[:tax_certification_fee]
    loan.flood_certification_fee = params[:flood_certification_fee]
    loan.outside_signing_service_fee = params[:outside_signing_service_fee]
    loan.concurrent_loan_charge_fee = params[:concurrent_loan_charge_fee]
    loan.endorsement_charge_fee = params[:endorsement_charge_fee]
    loan.lender_title_policy_fee = params[:lender_title_policy_fee]
    loan.recording_service_fee = params[:recording_service_fee]
    loan.settlement_agent_fee = params[:settlement_agent_fee]
    loan.recording_fees = params[:recording_fees]
    loan.owner_title_policy_fee = params[:owner_title_policy_fee]
    loan.prepaid_item_fee = params[:prepaid_item_fee]
    loan.prepaid_homeowners_insurance = params[:prepaid_homeowners_insurance]

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
    return if address_params.empty?

    address.assign_attributes(address_params)
    address.save!
  end

  private

  def address_params
    params.require(:address).permit(Address::PERMITTED_ATTRS)
  end
end
