require 'finance'

module HelpMeChooseServices
  class CalculateTotalCost
    attr_reader :zillow

    def call
    end

    private

    def total_fees
      @total_fees ||= zillow[:processing] + zillow[:loan_origination] + zillow[:appraisal] +
                      zillow[:credit_report] + zillow[:lender_credit]
    end

    def amortization
      @amortization ||= begin
        rate = Rate.new(zillow[:interest_rate], :apr, duration: zillow[:duration])
        Amortization.new(loan.amount, rate)
      end
    end

    def total_interest_paid
      @total_interest_paid ||= amortization.interest[0, expected_mortgage_duration].sum
    end

    def tax_adjusted_total_interest_paid
      @tax_adjusted_total_interest_paid ||= total_interest_paid * (1 - effective_rate_rate)
    end

    def cost_of_down_payment_and_total_fees
      cumulative_return = (1 + investment_return_rate) ** (expected_mortgage_duration / 12) - 1
      upfront_cash = zillow[:down_payment] + zillow[:total_fees]
      cumulative_return * upfront_cash
    end

    def cost_of_monthly_payment
      zillow[:monthly_payment] * ((1 + investment_return_rate / 12) ** expected_mortgage_duration - 1) / investment_return_rate
    end
  end
end