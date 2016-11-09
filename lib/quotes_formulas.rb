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
    quotes.select { |quote| quote["ProductFamily"] == "CONVENTIONAL" && (quote["Rate"].to_f / 0.125) == (quote["Rate"].to_f / 0.125).floor }
  end

  def get_apr(quote)
    quote["APR"] / 100
  end

  def get_lender_info(quotes)
    lender_names = quotes.map { |q| q["LenderName"] }.uniq
    lender_info = {}
    Lender.where(name: lender_names).each do |lender|
      lender_info[lender.name] = {
        nmls: lender.nmls,
        logo_url: lender.logo_url,
        commission: lender.commission,
        appraisal_fee: lender.appraisal_fee,
        tax_certification_fee: lender.tax_certification_fee,
        flood_certification_fee: lender.flood_certification_fee,
        lender_underwriting_fee: lender.lender_underwriting_fee
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

  def get_lender_credits(quote)
    return 0 if quote["DiscountPts"].nil?

    quote["DiscountPts"] / 100 * quote["FeeSet"]["LoanAmount"]
  end

  def get_total_closing_cost(quote, lender_underwriting_fee, thirty_fees = nil)
    lender_credit = get_lender_credits(quote)
    fha_upfront_premium_amount = get_fha_upfront_premium_amount(quote)
    thirty_fee = thirty_fees.nil? ? 0 : thirty_fees.map { |x| x[:FeeAmount] }.sum

    lender_underwriting_fee + lender_credit + fha_upfront_premium_amount + thirty_fee
  end

  def get_thirty_fees(fees, lender_info)
    thirty_fees = []

    if lender_info.present?
      thirty_fees << {
        "Description": "Appraisal Fee",
        "FeeAmount": lender_info[:appraisal_fee].to_i,
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }

      thirty_fees << {
        "Description": "Tax Certification Fee",
        "FeeAmount": lender_info[:tax_certification_fee].to_i,
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }

      thirty_fees << {
        "Description": "Flood Certification Fee",
        "FeeAmount": lender_info[:flood_certification_fee].to_i,
        "HubLine": 814,
        "FeeType": 1,
        "IncludeInAPR": false
      }
    end

    if fees.present?
      fees.each do |fee|
        thirty_fees += fee[:Fees]
      end
    end

    thirty_fees
  end

  def get_prepaid_fees(loan_amount, interest_rate)
    prepaid_items = []

    days = (Time.now.utc.end_of_month.to_date - Time.now.utc.to_date).to_i
    prepaid_items << {
      "Description": "Prepaid interest for #{days} days",
      "FeeAmount": loan_amount * interest_rate * days / 360,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    prepaid_items << {
      "Description": "Prepaid homeowners insurance for 12 months",
      "FeeAmount": 0,
      "HubLine": 814,
      "FeeType": 1,
      "IncludeInAPR": false
    }

    prepaid_items
  end

  def get_product_name(quote)
    PRODUCT.fetch(quote["ProductName"], quote["ProductName"])
  end

  def get_period(quote)
    return 360 if arm?(quote)

    quote["ProductTerm"].delete('F').to_i * 12
  end

  def get_interest_rate(quote)
    quote["Rate"].to_f / 100
  end

  def arm?(quote)
    quote["ProductType"].include? "ARM"
  end

  def get_fha_upfront_premium_amount(quote)
    quote["UFMIPPercent"].to_f * quote["FeeSet"]["LoanAmount"].to_f
  end
end
