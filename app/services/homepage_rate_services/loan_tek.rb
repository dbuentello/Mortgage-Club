module HomepageRateServices
  class LoanTek
    def self.call
      get_quotes
    end

    def self.get_quotes
      url = "https://api.loantek.com/Clients/WebServices/Client/#{ENV['LOANTEK_CLIENT_ID']}/Pricing/V2/Quotes/LoanPricer/#{ENV['LOANTEK_USER_ID']}"
      loan_purpose = 1
      connection = Faraday.new(url: url)
      response = connection.post do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.body = {
          BestExecutionMethodType: 2,
          LockPeriod: 30,
          QuotingChannel: 3,
          ClientDefinedIdentifier: ENV["LOANTEK_IDENTIFIER"],
          ZipCode: 94103,
          CreditScore: 760,
          LoanPurpose: loan_purpose,
          LoanAmount: 400000,
          LoanToValue: 80,
          PropertyUsage: 1,
          PropertyType: 1,
          QuoteTypesToReturn: [-1, 0, 1],
          LoanProgramsOfInterest: [1, 2, 3]
        }.to_json
      end
      response.status == 200 ? sort_rates(LoanTekServices::ReadQuotes.call(JSON.parse(response.body)["Quotes"], loan_purpose)) : []
    end

    def self.sort_rates(quotes)
      apr_30_year = 1
      apr_15_year = 1
      apr_5_libor = 1

      quotes.each do |quote|
        apr_30_year = quote[:apr] if quote[:product] == "30 year fixed" && quote[:apr] < apr_30_year
        apr_15_year = quote[:apr] if quote[:product] == "15 year fixed" && quote[:apr] < apr_15_year
        apr_5_libor = quote[:apr] if quote[:product] == "5/1 ARM" && quote[:apr] < apr_5_libor
      end

      {
        "apr_30_year" => apr_30_year == 1 ? nil : apr_30_year * 100,
        "apr_15_year" => apr_15_year == 1 ? nil : apr_15_year * 100,
        "apr_5_libor" => apr_5_libor == 1 ? nil : apr_5_libor * 100
      }
    end
  end
end
