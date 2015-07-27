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
    @loan = @loan || Loan.find(params[:id])

    rate = params['rate']

    @loan.attributes = {
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
    @loan.save

    render json: { message: "save loan successfully" }, status: :ok
  end

end
