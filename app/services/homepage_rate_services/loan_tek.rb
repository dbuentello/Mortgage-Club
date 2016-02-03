module HomepageRateServices
  class LoanTek
    def self.call
      get_quotes
    end

    def self.get_quotes
      url ="https://api.loantek.com/Clients/WebServices/Client/#{ENV["LOANTEK_CLIENT_ID"]}/Pricing/V2/Quotes/LoanPricer/#{ENV["LOANTEK_USER_ID"]}"
      connection = Faraday.new(url: url)
      response = connection.post do |conn|
        conn.headers["Content-Type"] = "application/json"
        conn.body = {
          BestExecutionMethodType: 1,
          QuotingChannel: 0,
          ClientDefinedIdentifier: ENV["LOANTEK_IDENTIFIER"],
          ZipCode: 94103,
          CreditScore: 760,
          LoanPurpose: 1,
          LoanAmount: 400000,
          LoanToValue: 80,
          PropertyUsage: 1,
          PropertyType: 1,
          QuoteTypesToReturn: [-1, 0, 1, 2, 3, 4]
        }.to_json
      end

      response.status == 200 ? sort_rates(JSON.parse(response.body)["Quotes"]) : []
    end

    def self.sort_rates(quotes)
      apr_30_year = 100
      apr_15_year = 100
      apr_5_libor = 100

      rates = quotes.each do |quote|
        apr_30_year = quote["APR"] if quote["ProductName"] == "30yearFixed" && quote["APR"] < apr_30_year
        apr_15_year = quote["APR"] if quote["ProductName"] == "15yearFixed" && quote["APR"] < apr_15_year
        apr_5_libor = quote["APR"] if quote["ProductName"] == "5yearARM" && quote["APR"] < apr_5_libor
      end

      {
        "apr_30_year" => apr_30_year,
        "apr_15_year" => apr_15_year,
        "apr_5_libor" => apr_5_libor
      }
    end
  end
end