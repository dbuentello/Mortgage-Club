# get initial quotes.
module LoanTekServices
  class GetInitialQuotes
    attr_accessor :info, :zip_code

    def initialize(info)
      @info = info
      @zip_code = ZipCode.find_by_zip(info["zip_code"])
    end

    def call
      quotes = get_quotes(get_loan_to_value, get_loan_amount)
      quotes_2 = []
      quotes_3 = []
      quotes_4 = []

      loan_to_value = get_loan_to_value
      if get_loan_purpose == "Refinance"
        if loan_to_value < 70
          quotes_2 = get_quotes(70, info["property_value"].to_f * 0.7, true)
        end
        if loan_to_value < 75
          quotes_3 = get_quotes(75, info["property_value"].to_f * 0.75, true)
        end
        if loan_to_value < 80 && get_property_usage == "PrimaryResidence"
          quotes_4 = get_quotes(80, info["property_value"].to_f * 0.8, true)
        end
      else
        property_usage = get_property_usage
        down_payment = 100 - loan_to_value

        if property_usage == "PrimaryResidence"
          if down_payment > 5
            quotes_2 = get_quotes(95, info["property_value"].to_f * 0.95, false, true)
          end
          if down_payment > 10
            quotes_3 = get_quotes(90, info["property_value"].to_f * 0.9, false, true)
          end
          if down_payment > 20
            quotes_4 = get_quotes(80, info["property_value"].to_f * 0.8, false, true)
          end
        else
          if down_payment > 20
            quotes_2 = get_quotes(80, info["property_value"].to_f * 0.8, false, true)
          end
          if down_payment > 25
            quotes_3 = get_quotes(75, info["property_value"].to_f * 0.75, false, true)
          end
        end
      end

      quotes = quotes + quotes_2 + quotes_3 + quotes_4
      quotes.sort_by { |program| [program[:interest_rate], program[:apr]] }
    end

    def lowest_apr
      quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: get_zipcode,
        credit_score: get_credit_score,
        loan_purpose: get_loan_purpose,
        loan_amount: get_loan_amount,
        loan_to_value: get_loan_to_value,
        property_usage: get_property_usage,
        property_type: get_property_type
      )

      if zip_code
        fees = CrawlFeesService.new(
          loan_purpose: get_loan_purpose,
          zip: zip_code.zip,
          city: zip_code.city,
          county: zip_code.county,
          loan_amount: get_loan_amount,
          sales_price: info["property_value"].to_f
        ).call

        if quotes.nil?
          []
        else
          quotes.empty? ? [] : LoanTekServices::ReadQuotes.build_lowest_apr(quotes, get_loan_purpose, fees, info["property_value"].to_f)
        end
      else
        if quotes.nil?
          []
        else
          quotes.empty? ? [] : LoanTekServices::ReadQuotes.build_lowest_apr(quotes, get_loan_purpose, [], info["property_value"].to_f)
        end
      end
    end

    private

    def get_credit_score
      info["credit_score"].to_i
    end

    def get_zipcode
      info["zip_code"]
    end

    def get_loan_purpose
      purchase_loan? ? "Purchase" : "Refinance"
    end

    def get_property_usage
      case info["property_usage"]
      when "primary_residence"
        usage = "PrimaryResidence"
      when "vacation_home"
        usage = "SecondaryOrVacation"
      when "rental_property"
        usage = "InvestmentOrRental"
      else
        usage = "NotSpecified"
      end
      usage
    end

    def get_property_type
      case info["property_type"]
      when "sfh"
        property_type = "SingleFamily"
      when "duplex", "multi_family"
        property_type = "MultiFamily2Units"
      when "triplex"
        property_type = "MultiFamily3Units"
      when "fourplex"
        property_type = "MultiFamily4Units"
      when "condo"
        property_type = "Condo"
      else
        property_type = "NotSpecified"
      end
      property_type
    end

    def get_loan_amount
      if purchase_loan?
        amount = info["property_value"].to_f - info["down_payment"].to_f
      else
        amount = info["mortgage_balance"].to_f
      end
      amount
    end

    def get_loan_to_value
      loan_amount = get_loan_amount
      (loan_amount * 100 / info["property_value"].to_f).round
    end

    def purchase_loan?
      info["mortgage_purpose"] == "purchase"
    end

    def get_quotes(loan_to_value, loan_amount, is_cash_out = false, is_down_payment = false)
      quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: get_zipcode,
        credit_score: get_credit_score,
        loan_purpose: get_loan_purpose,
        loan_amount: loan_amount,
        loan_to_value: loan_to_value,
        property_usage: get_property_usage,
        property_type: get_property_type
      )

      if zip_code
        fees = CrawlFeesService.new(
          loan_purpose: get_loan_purpose,
          zip: zip_code.zip,
          city: zip_code.city,
          county: zip_code.county,
          loan_amount: loan_amount,
          sales_price: info["property_value"].to_f
        ).call

        if (get_property_usage == "PrimaryResidence") && ((purchase_loan? && is_down_payment == false) || (!purchase_loan? && is_cash_out == false))
          params = {
            loan_purpose: get_loan_purpose,
            loan_amount: format("%0.0f", get_loan_amount),
            property_value: format("%0.0f", info["property_value"].to_f),
            county: zip_code.county,
            down_payment: purchase_loan? ? format("%0.0f", info["down_payment"].to_f) : ""
          }

          rates = WellsfargoServices::GetRates.new(params).call
          quote_hash = quotes.find { |q| q["ProductFamily"] == "CONVENTIONAL" }

          if quote_hash
            rates.each do |rate|
              quote = Marshal.load(Marshal.dump(quote_hash))
              quote["DiscountPts"] = 0
              quote["APR"] = rate[:apr]
              quote["Rate"] = rate[:interest_rate]
              quote["LenderName"] = rate[:lender_name]
              quote["ProductName"] = rate[:product_name]
              quote["ProductType"] = rate[:product_type]
              quote["ProductTerm"] = rate[:product_term]
              quotes << quote
            end
          end
        end

        if quotes.nil?
          []
        else
          quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, fees, info["property_value"].to_f, is_cash_out, is_down_payment)
        end
      else
        if quotes.nil?
          []
        else
          quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, [], info["property_value"].to_f, is_cash_out, is_down_payment)
        end
      end
    end
  end
end
