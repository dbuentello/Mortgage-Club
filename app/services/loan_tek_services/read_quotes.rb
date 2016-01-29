module LoanTekServices
  class ReadQuotes
    PRODUCT = {
      "15yearFixed" => "15 year fixed",
      "30yearFixed" => "30 year fixed",
      "5yearARM" => "5 year ARM",
      "40yearFixed" => "40 year fixed",
      "25yearFixed" => "25 year fixed",
      "20yearFixed" => "20 year fixed",
      "10yearFixed" => "10 year fixed",
      "7yearARM" => "7 year ARM",
      "3yearARM" => "3 year ARM",
      "1yearARM" => "1 year ARM"
    }

    def self.call(quotes)
      programs = quotes.map! do |quote|
        {
          lender_name: quote["LenderName"],
          product: get_product_name(quote),
          apr: quote["APR"] / 100,
          loan_amount: quote["FeeSet"]["LoanAmount"],
          interest_rate: get_interest_rate(quote),
          total_fee: quote["FeeSet"]["TotalFees"],
          fees: quote["FeeSet"]["Fees"] || [],
          period: get_period(quote),
          down_payment: get_down_payment(quote),
          monthly_payment: get_monthly_payment(quote),
          lender_credit: get_lender_credit(quote),
          total_closing_cost: get_total_closing_cost(quote),
          nmls: ""
        }
      end

      programs.sort_by { |program| program[:apr] }
    end

    def self.get_down_payment(quote)
      quote["FeeSet"]["LoanAmount"].to_f * 0.2
    end

    def self.get_monthly_payment(quote)
      period = get_period(quote)
      rate_per_period = get_interest_rate(quote) / 12
      numerator = rate_per_period * ((1 + rate_per_period) ** period)
      denominator = ((1 + rate_per_period) ** period) - 1
      payment = quote["FeeSet"]["LoanAmount"].to_f * (numerator / denominator)
      payment.round
    end

    def self.get_lender_credit(quote)
      quote["Fees"] < 0 ? quote["Fees"] : 0
    end

    def self.get_total_closing_cost(quote)
      total_fee = quote["FeeSet"]["TotalFees"].to_f
      lender_credit = get_lender_credit(quote)
      total_fee - lender_credit
    end

    def self.get_product_name(quote)
      PRODUCT[quote["ProductName"]]
    end

    def self.get_period(quote)
      quote["ProductTerm"].to_i * 12
    end

    def self.get_interest_rate(quote)
      quote["Rate"].to_f / 100
    end
  end
end
