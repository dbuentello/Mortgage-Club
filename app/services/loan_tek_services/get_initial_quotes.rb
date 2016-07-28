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
          city: zip_code.city,
          loan_amount: get_loan_amount,
          sales_price: info["property_value"].to_f
        ).call

        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, fees)
      else
        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, [])
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
          city: zip_code.city,
          loan_amount: get_loan_amount,
          sales_price: info["property_value"].to_f
        ).call

        quotes.empty? ? [] : LoanTekServices::ReadQuotes.build_lowest_apr(quotes, get_loan_purpose, fees)
      else
        quotes.empty? ? [] : LoanTekServices::ReadQuotes.build_lowest_apr(quotes, get_loan_purpose, [])
      end
    end

    private

    def get_loan_purpose
      purchase_loan? ? 1 : 2
    end

    def get_credit_score
      info["credit_score"].to_i
    end

    def get_zipcode
      info["zip_code"]
    end

    def get_property_usage
      case info["property_usage"]
      when "primary_residence"
        usage = 1
      when "vacation_home"
        usage = 2
      when "rental_property"
        usage = 3
      else
        usage = 0
      end
      usage
    end

    def get_property_type
      case info["property_type"]
      when "sfh"
        property_type = 1
      when "duplex", "multi_family"
        property_type = 11
      when "triplex"
        property_type = 12
      when "fourplex"
        property_type = 13
      when "condo"
        property_type = 3
      else
        property_type = 0
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
