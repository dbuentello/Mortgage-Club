module QuotesFormulas
  PRODUCT = {
    "40yearFixed" => "40 year fixed",
    "30yearFixed" => "30 year fixed",
    "25yearFixed" => "25 year fixed",
    "20yearFixed" => "20 year fixed",
    "15yearFixed" => "15 year fixed",
    "10yearFixed" => "10 year fixed",
    "7yearARM" => "7/1 ARM",
    "5yearARM" => "5/1 ARM",
    "3yearARM" => "3/1 ARM",
    "1yearARM" => "1/1 ARM"
  }

  PURCHASE = 1
  REFINANCE = 2

  def get_valid_quotes(quotes)
    quotes.select { |quote| quote["DiscountPts"] <= 0.125 }
  end

  def get_apr(quote)
    discount_pts_equals_to_0_125?(quote) ? get_interest_rate(quote) : quote["APR"] / 100
  end

  def get_lender_info(quotes)
    lender_names = quotes.map { |q| q["LenderName"] }.uniq
    lender_info = {}
    Lender.where(name: lender_names).each do |lender|
      lender_info[lender.name] = {
        nmls: lender.nmls,
        logo_url: lender.logo_url,
        appraisal_fee: lender.appraisal_fee,
        tax_certification_fee: lender.tax_certification_fee,
        flood_certification_fee: lender.flood_certification_fee
      }
    end

    lender_info
  end

  def get_down_payment(quote, loan_purpose)
    return nil if loan_purpose == REFINANCE || quote["LoanToValue"].nil?

    loan_amount = quote["FeeSet"]["LoanAmount"].to_f
    property_value = loan_amount / (quote["LoanToValue"].to_f / 100.0)

    property_value - loan_amount
  end

  def get_monthly_payment(quote)
    period = get_period(quote)
    rate_per_period = get_interest_rate(quote) / 12
    numerator = rate_per_period * ((1 + rate_per_period)**period)
    denominator = ((1 + rate_per_period)**period) - 1
    payment = quote["FeeSet"]["LoanAmount"].to_f * (numerator / denominator)
    payment.round
  end

  def get_lender_credits(quote, admin_fee)
    return 0 if quote["DiscountPts"].nil?
    return 0 if quote["DiscountPts"].to_f >= 0 && quote["DiscountPts"].to_f <= 0.125

    quote["DiscountPts"] / 100 * quote["FeeSet"]["LoanAmount"] + admin_fee
    # return 0 if total_fee >= 0 && total_fee <= 1000
    # total_fee
  end

  def get_total_closing_cost(quote, admin_fee, thirty_fees = nil)
    total_fee = get_total_fee(quote, admin_fee)
    lender_credit = get_lender_credits(quote, admin_fee)
    fha_upfront_premium_amount = get_fha_upfront_premium_amount(quote)
    thirty_fee = thirty_fees.nil? ? 0 : thirty_fees[:FeeAmount]

    total_fee + lender_credit + fha_upfront_premium_amount + thirty_fee
  end

  def get_admin_fee(quote)
    return 0 unless quote["FeeSet"]
    return 0 unless quote["FeeSet"]["Fees"]

    admin_fee = quote["FeeSet"]["Fees"].find { |x| x["Description"] == "Administration fee" }

    return 0 unless admin_fee

    admin_fee["FeeAmount"].to_f
  end

  def get_fees(quote)
    return [] unless quote["FeeSet"]
    return [] unless quote["FeeSet"]["Fees"]

    quote["FeeSet"]["Fees"].reject { |x| x["Description"] == "Administration fee" }
  end

  def get_thirty_fees(fees, lender_info)
    thirty_fees = []

    thirty_fees += fees if fees.present?

    if lender_info.present?
      thirty_fees << {
        "Description": "Appraisal Fee",
        "FeeAmount": lender_info[:appraisal_fee],
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }

      thirty_fees << {
        "Description": "Tax Certification Fee",
        "FeeAmount": lender_info[:tax_certification_fee],
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }

      thirty_fees << {
        "Description": "Flood Certification Fee",
        "FeeAmount": lender_info[:flood_certification_fee],
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }
    end

    {
      "Description": "Third Party Fees",
      "FeeAmount": thirty_fees.map { |x| x[:FeeAmount] }.sum,
      "Fees": thirty_fees
    }
  end

  def get_total_fee(quote, admin_fee)
    quote["FeeSet"]["TotalFees"].to_f - admin_fee
  end

  def get_product_name(quote)
    PRODUCT.fetch(quote["ProductName"], quote["ProductName"])
  end

  def get_period(quote)
    return 360 if arm?(quote)

    quote["ProductTerm"].to_i * 12
  end

  def get_interest_rate(quote)
    quote["Rate"].to_f / 100
  end

  def arm?(quote)
    quote["ProductTerm"].include? "/1"
  end

  def discount_pts_equals_to_0_125?(quote)
    quote["DiscountPts"] == 0.125
  end

  def hide_admin_fee?(quote, admin_fee)
    # total_fee = quote["DiscountPts"].to_f / 100 * quote["FeeSet"]["LoanAmount"].to_f + admin_fee
    # return true if total_fee >= 0 && total_fee <= 1000
    false
  end

  def get_fha_upfront_premium_amount(quote)
    quote["UFMIPPercent"].to_f * quote["FeeSet"]["LoanAmount"].to_f
  end
end
