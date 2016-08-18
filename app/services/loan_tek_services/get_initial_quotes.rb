# get initial quotes.
module LoanTekServices
  class GetInitialQuotes
    attr_accessor :info

    def initialize(info)
      @info = info
    end

    def call
      quotes = get_quotes(get_loan_to_value, get_loan_amount)
      quotes_2 = []
      quotes_3 = []
      quotes_4 = []

      if get_loan_purpose == "Refinance"
        loan_to_value = get_loan_to_value
        if loan_to_value < 70
          quotes_2 = get_quotes(70, info["property_value"].to_f * 0.7, true)
        end
        if loan_to_value < 75
          quotes_3 = get_quotes(75, info["property_value"].to_f * 0.75, true)
        end
        if loan_to_value < 80 && get_property_usage == "PrimaryResidence"
          quotes_4 = get_quotes(80, info["property_value"].to_f * 0.8, true)
        end
      end
      quotes = quotes + quotes_2 + quotes_3 + quotes_4
      quotes.sort_by { |program| program[:apr] }
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

      zip_code = ZipCode.find_by_zip(get_zipcode)

      if zip_code
        fees = CrawlFeesService.new(
          loan_purpose: get_loan_purpose,
          zip: zip_code.zip,
          city: zip_code.city,
          county: zip_code.county,
          loan_amount: get_loan_amount,
          sales_price: info["property_value"].to_f
        ).call

        quotes.empty? ? [] : LoanTekServices::ReadQuotes.build_lowest_apr(quotes, get_loan_purpose, fees, info["property_value"].to_f)
      else
        quotes.empty? ? [] : LoanTekServices::ReadQuotes.build_lowest_apr(quotes, get_loan_purpose, [], info["property_value"].to_f)
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

    def get_quotes(loan_to_value, loan_amount, is_cash_out = false)
      quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: get_zipcode,
        credit_score: get_credit_score,
        loan_purpose: get_loan_purpose,
        loan_amount: loan_amount,
        loan_to_value: loan_to_value,
        property_usage: get_property_usage,
        property_type: get_property_type
      )

      zip_code = ZipCode.find_by_zip(get_zipcode)
      if zip_code
        fees = CrawlFeesService.new(
          loan_purpose: get_loan_purpose,
          zip: zip_code.zip,
          city: zip_code.city,
          county: zip_code.county,
          loan_amount: loan_amount,
          sales_price: info["property_value"].to_f
        ).call

        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, fees, info["property_value"].to_f, is_cash_out)
      else
        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, [], info["property_value"].to_f, is_cash_out)
      end
    end
  end
end
