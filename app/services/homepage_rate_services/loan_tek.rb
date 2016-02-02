module HomepageRateServices
  class LoanTek
    def self.call
      get_quotes
    end

    def self.get_quotes
      url ="https://api.loantek.com/Clients/WebServices/Client/#{ENV["LOANTEK_CLIENT_ID"]}/Pricing/V2/Quotes/LoanPricer/#{ENV["LOANTEK_USER_ID"]}"
      connection = Faraday.new(url: url)
      @response = connection.post do |conn|
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

      @response.status == 200 ? get_rates(JSON.parse(@response.body)["Quotes"]) : []
    end

    def self.get_rates(quotes)
      rates = quotes.map! do |quote|
        if product_name_valid?(quote)
          {
            product: quote["ProductName"],
            apr: quote["APR"] / 100
          }
        end
      end

      rates.compact

      apr_30_year = 1
      apr_15_year = 1
      apr_5_libor = 1

      rates.each do |rate|
        apr_30_year = rate[:apr] if rate[:product] == "30yearFixed" && rate[:apr] < apr_30_year
        apr_15_year = rate[:apr] if rate[:product] == "15yearFixed" && rate[:apr] < apr_15_year
        apr_5_libor = rate[:apr] if rate[:product] == "5yearARM" && rate[:apr] < apr_5_libor
      end

      {
        "apr_30_year" => apr_30_year * 100,
        "apr_15_year" => apr_15_year * 100,
        "apr_5_libor" => apr_5_libor * 100
      }
    end

    def self.product_name_valid?(quote)
      name = quote["ProductName"]

      name == "30yearFixed" || name == "15yearFixed" || name == "5yearARM"
    end
  end
end
