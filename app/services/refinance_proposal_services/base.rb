module RefinanceProposalServices
  class Base
    attr_reader :address, :zipcode
    LENDER_AVG_OVERLAY = 0.0025

    def initialize(address, zipcode)
      @address = address
      @zipcode = zipcode
    end

    def call
      reil_data = get_data_from_reil
      return unless reil_data

      zillow_data = get_data_from_zillow
      original_interest_rate = get_original_interest_rate(reil_data[:original_loan_date])
      loan_tek_data = get_data_from_loan_tek(reil_data[:property_value], reil_data[:loan_amount], reil_data[:zipcode], original_interest_rate, zillow_data[:property_type])

      RefinanceProposalServices::AutomateRefinanceProposal.new(
        old_loan_amount: reil_data[:loan_amount],
        old_interest_rate: original_interest_rate,
        new_interest_rate: loan_tek_data[:new_interest_rate],
        new_interest_rate_cash_out: loan_tek_data[:new_interest_rate_cash_out],
        periods: 360,
        lender_credit: loan_tek_data[:lender_credit],
        lender_credit_cash_out: loan_tek_data[:lender_credit_cash_out],
        estimated_closing_costs: loan_tek_data[:estimated_closing_costs],
        estimated_closing_costs_cash_out: loan_tek_data[:estimated_closing_costs_cash_out],
        original_loan_date: reil_data[:original_loan_date],
        current_home_value: zillow_data[:current_home_value]
      ).call
    end

    private

    def get_data_from_reil
      # hardcode
      {
        property_value: 500_000,
        loan_amount: 400_000,
        zipcode: "95127",
        original_loan_date: DateTime.strptime("8/20/2013", "%m/%d/%Y")
      }
    end

    def get_data_from_zillow
      ZillowService::GetHomeValueAndPropertyType.call(address, zipcode)
    end

    def get_data_from_loan_tek(property_value, loan_amount, zipcode, original_interest_rate, property_type)
      lower_rate_refinance_data = LoanTekServices::GetDataForLowerRateRefinance.new(property_value, loan_amount, zipcode, original_interest_rate, property_type)
      cash_out_refinance_data = LoanTekServices::GetDataForCashOutRefinance.new(property_value, loan_amount, zipcode, original_interest_rate, property_type)
      lower_rate_refinance_data.merge(cash_out_refinance_data)
    end

    def get_original_interest_rate(original_loan_date)
      return unless avg_rate_lock_in_date = get_avg_rate_lock_in_date(original_loan_date)
      ((avg_rate_lock_in_date + LENDER_AVG_OVERLAY) / 0.00125) * 0.00125
    end

    def get_avg_rate_lock_in_date(original_loan_date)
      if fred_economic = FredEconomic.where(event_date: original_loan_date.to_date.to_s).last
        fred_economic.year_fixed_30
      end
    end
  end
end
