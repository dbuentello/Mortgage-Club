module LoanTekServices
  class SendRequestToLoanTek
    def self.call(params)
      url = "https://api.loantek.com/ClientsV3/WebServices/Client/#{client_id}/Pricing/V3/Quotes/LoanPricer/#{user_id}"
      connection = Faraday.new(url: url)
      @response = connection.post do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.body = {
          BestExecutionMethodType: execution_method,
          QuotingChannel: quoting_channel,
          ClientDefinedIdentifier: client_defined_identifier,
          LockPeriod: lock_period,
          QuoteTypesToReturn: quote_types_to_return,
          LoanProgramsOfInterest: loan_programs_of_interest,
          ZipCode: params[:zipcode],
          CreditScore: params[:credit_score],
          LoanPurpose: params[:loan_purpose],
          LoanAmount: params[:loan_amount].to_i,
          LoanToValue: params[:loan_to_value],
          PropertyUsage: params[:property_usage],
          PropertyType: params[:property_type],
          ProductFamily: product_family,
          FHALoan: false
        }.to_json
      end

      success? ? JSON.parse(@response.body)["Quotes"] : []
    end

    def self.client_id
      ENV["LOANTEK_CLIENT_ID"]
    end

    def self.user_id
      ENV["LOANTEK_USER_ID"]
    end

    def self.client_defined_identifier
      ENV["LOANTEK_IDENTIFIER"]
    end

    def self.lock_period
      # 30 days
      "D30"
    end

    def self.execution_method
      "ByRate"
    end

    def self.quoting_channel
      "LoanTek"
    end

    def self.loan_programs_of_interest
      ["ThirtyYearFixed", "FifteenYearFixed", "FiveYearARM", "SevenYearARM"]
    end

    def self.quote_types_to_return
      ["ClosestToZeroNoFee", "ClosestToZeroWithFee", "ClosestTo01"]
    end

    def self.success?
      @response.status == 200
    end

    def self.product_family
      "CONVENTIONAL"
    end
  end
end
