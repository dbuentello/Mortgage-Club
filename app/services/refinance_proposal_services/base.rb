module RefinanceProposalServices
  class Base
    attr_reader :reil_data
    LENDER_AVG_OVERLAY = 0.0025

    def initialize(reil_data)
      @reil_data = reil_data
    end

    def call
      return {
        data: "Data was not found on Reil",
        status_code: 404
      } unless reil_data = get_data_from_reil

      return {
        data: "Data was not found on Zillow",
        status_code: 404
      } unless zillow_data = get_data_from_zillow(reil_data[:address], reil_data[:zipcode])

      return {
        data: "Original interest rate was not found",
        status_code: 404
      } unless original_interest_rate = get_original_interest_rate(reil_data[:original_loan_date])

      return {
        data: "Data was not found on LoanTek",
        status_code: 404
      } unless loan_tek_data = get_data_from_loan_tek(reil_data[:property_value], reil_data[:loan_amount], reil_data[:zipcode], original_interest_rate, zillow_data[:property_type])

      loan_tek_data = {
        new_interest_rate: 0.0375,
        estimated_closing_costs: -1838.0,
        lender_credit: -3785.0,
        new_interest_rate_cash_out: 0.0375,
        estimated_closing_costs_cash_out: -1838.0,
        lender_credit_cashout: -3785.0
      }

      result = RefinanceProposalServices::AutomateRefinanceProposal.new(
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

      result.merge(reil_data) if result
    end

    private

    def get_data_from_reil
      return unless reil_data["mortgage_histories"]
      return unless mortgage_history = reil_data["mortgage_histories"].first

      {
        facebook_id: reil_data["facebook_id"],
        timestamp: reil_data["timestamp"],
        property_value: mortgage_history["mortgage_amount"].to_f,
        loan_amount: mortgage_history["mortgage_amount"].to_f * 0.8,
        zipcode: reil_data["zipcode"],
        address: reil_data["address"],
        original_loan_date: DateTime.strptime(mortgage_history["mortgage_date"], "%m/%d/%Y")
      }
    end

    def get_data_from_zillow(address, zipcode)
      ZillowService::GetHomeValueAndPropertyType.call(address, zipcode)
    end

    def get_data_from_loan_tek(property_value, loan_amount, zipcode, original_interest_rate, property_type)
      return unless lower_rate_refinance_data = LoanTekServices::GetDataForLowerRateRefinance.new(property_value, loan_amount, zipcode, original_interest_rate, property_type).call
      return unless cash_out_refinance_data = LoanTekServices::GetDataForCashOutRefinance.new(property_value, loan_amount, zipcode, original_interest_rate, property_type).call

      lower_rate_refinance_data.merge(cash_out_refinance_data)
    end

    def get_original_interest_rate(original_loan_date)
      return unless avg_rate_lock_in_date = get_avg_rate_lock_in_date(original_loan_date)

      ((avg_rate_lock_in_date.to_f / 100 + LENDER_AVG_OVERLAY) / 0.00125) * 0.00125
    end

    def get_avg_rate_lock_in_date(original_loan_date)
      if fred_economic = FredEconomic.where("event_date <= ?", original_loan_date.to_date.to_s).order(:event_date).last
        fred_economic.year_fixed_30
      end
    end
  end
end
