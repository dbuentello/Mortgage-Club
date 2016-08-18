# get quotes for borrower (after complete loan's steps).
module LoanTekServices
  class GetQuotes
    attr_reader :loan, :property, :borrower, :response

    def initialize(loan)
      @loan = loan
      @property = loan.subject_property
      @borrower = loan.borrower
      @response = []
    end

    # https://api.loantek.com/Clients/Views/Quoting/LoanRequest-LoanPricer-v2.cshtml
    def call
      cache_key = "loantek-quotes-#{loan.id}-#{loan.updated_at}-#{property.updated_at}-#{get_credit_score}"

      if quotes = REDIS.get(cache_key)
        quotes = JSON.parse(quotes, symbolize_names: true)
      else
        quotes = get_quotes(get_loan_to_value, get_loan_amount)
        quotes_2 = []
        quotes_3 = []
        quotes_4 = []

        # if get_loan_purpose == "Refinance"
        #   loan_to_value = get_loan_to_value
        #   if loan_to_value < 70
        #     quotes_2 = get_quotes(70, get_loan_amount * 0.7, true)
        #   end
        #   if loan_to_value < 75
        #     quotes_3 = get_quotes(75, get_loan_amount * 0.75, true)
        #   end
        #   if loan_to_value < 80 && get_property_usage == "PrimaryResidence"
        #     quotes_4 = get_quotes(80, get_loan_amount * 0.8, true)
        #   end
        # end

        quotes = (quotes += quotes_2 += quotes_3 += quotes_4).sort_by { |program| program[:apr] }
        REDIS.set(cache_key, quotes.to_json)
        REDIS.expire(cache_key, 30.minutes.to_i)
      end

      quotes
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
          sales_price: get_property_value
        ).call

        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, fees, get_property_value, is_cash_out)
      else
        quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose, [], get_property_value, is_cash_out)
      end
    end

    private

    def get_zipcode
      property.address.zip
    end

    def get_credit_score
      borrower.credit_report.score.to_i
    end

    def get_loan_purpose
      purpose = "NotSpecified"
      if loan.purchase?
        purpose = "Purchase"
      elsif loan.refinance?
        purpose = "Refinance"
      end

      purpose
    end

    def get_loan_amount
      loan.amount.to_i
    end

    def get_loan_to_value
      loan_amount = get_loan_amount
      property_value = get_property_value
      (loan_amount * 100 / property_value).round
    end

    def get_property_value
      loan.purchase? ? property.purchase_price : property.market_price
    end

    def get_property_usage
      case property.usage
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
      case property.property_type
      when "sfh"
        property_type = "SingleFamily"
      when "duplex"
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
  end
end
