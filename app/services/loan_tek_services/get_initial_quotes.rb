module LoanTekServices
  class GetInitialQuotes
    attr_accessor :info, :response

    def initialize(info)
      @info = info
      @response = []
    end

    def call
      url ="https://api.loantek.com/Clients/WebServices/Client/#{ENV["LOANTEK_CLIENT_ID"]}/Pricing/V2/Quotes/LoanPricer/#{ENV["LOANTEK_USER_ID"]}"
      connection = Faraday.new(url: url)
      @response = connection.post do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.body = {
          BestExecutionMethodType: 1,
          QuotingChannel: 0,
          ClientDefinedIdentifier: ENV["LOANTEK_IDENTIFIER"],
          LoanToValue: 80,
          QuoteTypesToReturn: [0],
          ZipCode: get_zip_code,
          CreditScore: get_credit_score,
          LoanPurpose: get_loan_purpose,
          LoanAmount: get_loan_amount,
          PropertyUsage: get_property_usage,
          PropertyType: get_property_type
        }.to_json
      end

      success? ? LoanTekServices::ReadQuotes.call(JSON.parse(response.body)["Quotes"]) : []
    end

    private

    def get_loan_purpose
      info[:mortgage_purpose] == "purchase" ? 1 : 2
    end

    def get_credit_score
      info[:credit_score].to_i
    end

    def get_zip_code
      info[:zip_code]
    end

    def get_property_usage
      case info[:property_usage]
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
      case info[:property_type]
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

    def get_loan_amount
      info[:property_value].to_f * 0.8
    end

    def success?
      response.status == 200
    end
  end
end

