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
      cache_key = "loantek-quotes-#{loan.id}-#{loan.updated_at}-#{property.updated_at}-#{credit_score}"

      if quotes = REDIS.get(cache_key)
        quotes = JSON.parse(quotes)
      else
        quotes = get_quotes
        REDIS.set(cache_key, quotes.to_json)
        REDIS.expire(cache_key, 30.minutes.to_i)
      end

      quotes
    end

    private

    def get_quotes
      url ="https://api.loantek.com/Clients/WebServices/Client/#{client_id}/Pricing/V2/Quotes/LoanPricer/#{user_id}"
      connection = Faraday.new(url: url)
      @response = connection.post do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.body = {
          BestExecutionMethodType: execution_method,
          QuotingChannel: quoting_channel,
          ClientDefinedIdentifier: client_defined_identifier,
          ZipCode: zipcode,
          CreditScore: credit_score,
          LoanPurpose: loan_purpose,
          LoanAmount: loan_amount,
          LoanToValue: loan_to_value,
          PropertyUsage: property_usage,
          PropertyType: property_type,
          QuoteTypesToReturn: quote_types_to_return
        }.to_json
      end

      success? ? LoanTekServices::ReadQuotes.call(JSON.parse(response.body)["Quotes"]) : []
    end

    def client_id
      ENV["LOANTEK_CLIENT_ID"]
    end

    def user_id
      ENV["LOANTEK_USER_ID"]
    end

    def client_defined_identifier
      ENV["LOANTEK_IDENTIFIER"]
    end

    def execution_method
      1
    end

    def quoting_channel
      0
    end

    def zipcode
      property.address.zip
    end

    def credit_score
      borrower.credit_score.to_i
    end

    def loan_purpose
      purpose = 0
      if loan.purchase?
        purpose = 1
      elsif loan.refinance?
        purpose = 2
      end

      purpose
    end

    def loan_amount
      loan.amount.to_i
    end

    def loan_to_value
      property_value = loan.purchase? ? property.purchase_price : property.market_price
      (loan_amount * 100 / property_value).round(3)
    end

    def property_usage
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

    def property_type
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

    def loan_programs
      # get all programs
      [0]
    end

    def quote_types_to_return
      [-1, 0, 1, 2, 3, 4]
    end

    def success?
      response.status == 200
    end
  end
end
