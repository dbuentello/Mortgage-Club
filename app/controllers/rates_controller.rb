class RatesController < ApplicationController
  before_action :set_loan, only: [:select]

  def index
    bootstrap

    respond_to do |format|
      format.html { render template: 'client_app' }
      format.json { render json: Rate.get_rates }
    end
  end

  def select
    loan = @loan

    # update loan attribute which can get from the font-end (already get by reading xml file)
    rate = params['rate']
    loan.attributes = {
      lender_name: rate['EntityName'],
      fha_upfront_premium_amount: rate['FHAUpfrontPremiumAmount'],
      num_of_months: rate['LoanAmortizationTermMonths'],
      term_months: rate['LoanTermMonths'],
      lock_period: rate['LockPeriod'],
      margin: rate['Margin'],
      pmi_annual_premium_mount: rate['MIAnnualPremiumAmount'],
      pmi_monthly_premium_amount: rate['MIMonthlyPremiumAmount'],
      pmi_monthly_premium_percent: rate['MIMonthlyPremiumPercent'],
      pmi_required: Rate.convert_text_to_boolean(rate['MIRequiredForLoan']),
      apr: rate['OriginationAPR'],
      monthly_payment: rate['OriginationPandI'],
      estimated_closing_costs: rate['OriginationTotalClosingCost'],
      price: rate['Price'],
      product_code: rate['ProductCode'],
      product_index: rate['ProductIndex'],
      interest_rate: rate['Rate'],
      total_margin_adjustment: rate['TotalMarginAdjustment'],
      total_price_adjustment: rate['TotalPriceAdjustment'],
      total_rate_adjustment: rate['TotalRateAdjustment'],
      srp_adjustment: rate['TotalSRPAdjustment']
    }

    # call LoanSifter API to get further fee info
    fee = Rate.get_fee
    loan.attributes = {
      appraisal_fee: fee[0]['RESPAFeeTotalCalculatedAmount'],
      city_county_deed_stamp_fee: fee[1]['RESPAFeeTotalCalculatedAmount'],
      credit_report_fee: fee[2]['RESPAFeeTotalCalculatedAmount'],
      document_preparation_fee: fee[3]['RESPAFeeTotalCalculatedAmount'],
      flood_certification: fee[4]['RESPAFeeTotalCalculatedAmount'],
      origination_fee: fee[5]['RESPAFeeTotalCalculatedAmount'],
      settlement_fee: fee[6]['RESPAFeeTotalCalculatedAmount'],
      state_deed_tax_stamp_fee: fee[7]['RESPAFeeTotalCalculatedAmount'],
      tax_related_service_fee: fee[8]['RESPAFeeTotalCalculatedAmount'],
      title_insurance_fee: fee[9]['RESPAFeeTotalCalculatedAmount']
    }
    loan.save

    render json: {message: "save loan successfully"}, status: :ok
  end

end
