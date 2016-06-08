#
# Module LoanTekServices provides methods to get, process and return list rates from LoanTek
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
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
        quotes = JSON.parse(quotes)
      else
        quotes = get_quotes
        REDIS.set(cache_key, quotes.to_json)
        REDIS.expire(cache_key, 30.minutes.to_i)
      end

      quotes
    end

    def get_quotes
      quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: get_zipcode,
        credit_score: get_credit_score,
        loan_purpose: get_loan_purpose,
        loan_amount: get_loan_amount,
        loan_to_value: get_loan_to_value,
        property_usage: get_property_usage,
        property_type: get_property_type
      )

      quotes.empty? ? [] : LoanTekServices::ReadQuotes.call(quotes, get_loan_purpose)
    end

    private

    def get_zipcode
      property.address.zip
    end

    def get_credit_score
      borrower.credit_score.to_i
    end

    def get_loan_purpose
      purpose = 0
      if loan.purchase?
        purpose = 1
      elsif loan.refinance?
        purpose = 2
      end

      purpose
    end

    def get_loan_amount
      loan.amount.to_i
    end

    def get_loan_to_value
      loan_amount = get_loan_amount
      property_value = loan.purchase? ? property.purchase_price : property.market_price
      (loan_amount * 100 / property_value).round
    end

    def get_property_usage
      case property.usage
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
      case property.property_type
      when "sfh"
        property_type = 1
      when "duplex"
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
  end
end
