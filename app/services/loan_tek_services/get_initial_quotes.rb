# get initial quotes.
module LoanTekServices
  class GetInitialQuotes
    attr_accessor :info

    def initialize(info)
      @info = info
    end

    def call
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

        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, fees, info["property_value"].to_f)
      else
        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, [], info["property_value"].to_f)
      end
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
  end
end
