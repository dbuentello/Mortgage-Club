# check if quotes are available with user's demand
module LoanTekServices
  class CheckQuotesForSlackBot
    attr_reader :data, :context, :response

    def initialize(params)
      @data = params["initial_quote"]["result"] if params["initial_quote"].present? && params["initial_quote"]["result"].present?
      @context = data["contexts"].first if @data
      @response = []
    end

    def call
      return false unless data && context

      url = "https://api.loantek.com/Clients/WebServices/Client/#{ENV['LOANTEK_CLIENT_ID']}/Pricing/V2/Quotes/LoanPricer/#{ENV['LOANTEK_USER_ID']}"
      connection = Faraday.new(url: url)
      @response = connection.post do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.body = {
          BestExecutionMethodType: 3,
          LockPeriod: 30,
          QuotingChannel: 0,
          ClientDefinedIdentifier: ENV["LOANTEK_IDENTIFIER"],
          LoanToValue: loan_to_value,
          QuoteTypesToReturn: [-1, 0],
          ZipCode: zip_code,
          CreditScore: credit_score,
          LoanPurpose: loan_purpose,
          LoanAmount: loan_amount,
          PropertyUsage: usage,
          PropertyType: property_type,
          LoanProgramsOfInterest: [1, 2, 3]
        }.to_json
      end

      success? && quotes_are_present?
    end

    def query_content
      {
        zip_code: zip_code,
        credit_score: credit_score,
        mortgage_purpose: context["parameters"]["purpose"],
        property_value: property_value,
        property_usage: context["parameters"]["usage"],
        property_type: context["parameters"]["property_type"],
        down_payment: down_payment,
        mortgage_balance: mortgage_balance
      }.to_json
    end

    private

    def loan_to_value
      (loan_amount * 100 / property_value).round(3)
    end

    def zip_code
      context["parameters"]["zipcode"].to_i
    end

    def credit_score
      return unless data["parameters"]

      data["parameters"]["credit_score"].to_i
    end

    def loan_purpose
      if purchase_loan?
        purpose = 1
      elsif refinance_loan?
        purpose = 2
      end

      purpose
    end

    def loan_amount
      if purchase_loan?
        amount = property_value - down_payment
      elsif refinance_loan?
        amount = mortgage_balance
      end

      amount
    end

    def usage
      case context["parameters"]["usage"]
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
      case context["parameters"]["property_type"]
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

    def property_value
      context["parameters"]["property_value"].to_i
    end

    def mortgage_balance
      context["parameters"]["mortgage_balance"].to_i
    end

    def down_payment
      context["parameters"]["down_payment"].to_i
    end

    def purchase_loan?
      context["parameters"]["purpose"] == "purchase"
    end

    def refinance_loan?
      context["parameters"]["purpose"] == "refinance"
    end

    def success?
      response.status == 200
    end

    def quotes_are_present?
      result = JSON.parse(response.body)
      result.present? && result["Quotes"].present?
    end
  end
end
