module LoanTekServices
  class SendRequestToLoanTek
    def self.call(params)
      url = "https://api.loantek.com/Clients/WebServices/Client/#{client_id}/Pricing/V2/Quotes/LoanPricer/#{user_id}"
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
          LoanAmount: params[:loan_amount],
          LoanToValue: params[:loan_to_value],
          PropertyUsage: params[:property_usage],
          PropertyType: params[:property_type],
          CashOut: true
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
      30
    end

    def self.execution_method
      # By Rate
      2
    end

    def self.quoting_channel
      # LoanTek
      3
    end

    def self.loan_programs_of_interest
      [1, 2, 3]
    end

    def self.quote_types_to_return
      [-1, 0, 1]
    end

    def self.success?
      @response.status == 200
    end
  end
end
