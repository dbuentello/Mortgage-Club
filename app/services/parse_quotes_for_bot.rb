module ParseQuotesForBot
  include ActionView::Helpers::NumberHelper

  def get_valid_quotes(quotes)
    quotes.select { |quote| quote["DiscountPts"] <= 0.125 }
  end

  def calculate_lender_credit(program)
    (program["DiscountPts"].to_f / 100 * program["FeeSet"]["LoanAmount"].to_f).abs.to_i
  end

  def calculate_apr(program)
    program["DiscountPts"] == 0.125 ? program["Rate"] : program["APR"]
  end
end