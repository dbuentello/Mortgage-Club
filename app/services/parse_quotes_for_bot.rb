module ParseQuotesForBot
  include ActionView::Helpers::NumberHelper

  def get_valid_quotes(quotes)
    quotes.select { |quote| quote["ProductFamily"] == "CONVENTIONAL" }
  end

  def calculate_apr(program)
    program["APR"]
  end

  def get_monthly_payment(quote)
    period = get_period(quote)
    rate_per_period = get_interest_rate(quote) / 12
    numerator = rate_per_period * ((1 + rate_per_period)**period)
    denominator = ((1 + rate_per_period)**period) - 1
    payment = quote["FeeSet"]["LoanAmount"].to_f * (numerator / denominator)
    payment.round
  end

  def get_total_closing_cost(quote, admin_fee)
    total_fee = get_total_fee(quote, admin_fee)
    lender_credit = get_lender_credits(quote, admin_fee)

    total_fee + lender_credit
  end

  def get_total_fee(quote, admin_fee)
    quote["FeeSet"]["TotalFees"].to_f - admin_fee
  end

  def get_admin_fee(quote)
    return 0 unless quote["FeeSet"]
    return 0 unless quote["FeeSet"]["Fees"]

    admin_fee = quote["FeeSet"]["Fees"].find { |q| q["Description"] == "Administration fee" }

    return 0 unless admin_fee

    admin_fee["FeeAmount"].to_f
  end

  def get_period(quote)
    return 360 if arm?(quote)

    quote["ProductTerm"].delete('F').to_i * 12
  end

  def get_interest_rate(quote)
    quote["Rate"].to_f / 100
  end

  def get_lender_credits(quote, admin_fee)
    return 0 if quote["DiscountPts"].nil?

    quote["DiscountPts"] / 100 * quote["FeeSet"]["LoanAmount"] + admin_fee
  end

  def arm?(quote)
    quote["ProductType"].include? "ARM"
  end
end
