require 'capybara'
require 'capybara/poltergeist'

module ZillowService
  class GetMortgageRate
    include HTTParty
    include Capybara::DSL

    def self.call(zipcode)
      return unless zipcode

      zipcode = zipcode[0..4] if zipcode.length > 5
      cache_key = "zillow-mortgage-rates-#{zipcode}"

      if lenders = REDIS.get(cache_key)
        lenders = JSON.parse(lenders)
      else
        set_up_crawler
        lenders = get_lenders(zipcode)
        REDIS.set(cache_key, lenders.to_json)
        REDIS.expire(cache_key, 8.hour.to_i)
      end
      lenders
    end

    private

    def self.set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {js_errors: false, timeout: 60})
      end
      @session = Capybara::Session.new(:poltergeist)
      @session.driver.headers = {'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)"}
    end

    def self.get_request_code(zipcode)
      user_session_id = "userSessionId=2de70907-6e58-45f6-a7e8-dc2efb69e261" # hardcode session ID
      @session.visit "https://mortgageapi.zillow.com/submitRequest?"\
                      "property.type=SingleFamilyHome&property.use=Primary"\
                      "&property.zipCode=#{zipcode}&property.value=500000"\
                      "&borrower.creditScoreRange=R_760_&borrower.annualIncome=200000"\
                      "&borrower.monthlyDebts=0&borrower.selfEmployed=false"\
                      "&borrower.hasBankruptcy=false&borrower.hasForeclosure=false"\
                      "&desiredPrograms.0=Fixed30Year&desiredPrograms.1=Fixed15Year"\
                      "&desiredPrograms.2=ARM5&desiredPrograms.3=Fixed20Year"\
                      "&desiredPrograms.4=Fixed10Year&desiredPrograms.5=ARM7"\
                      "&desiredPrograms.6=ARM3&purchase.downPayment=100000"\
                      "&purchase.firstTimeBuyer=false&purchase.newConstruction=false"\
                      "&partnerId=RD-CZMBMCZ&#{user_session_id}"
      request_code = @session.text.split('":"').last.chomp('"}')
    end

    def self.get_lenders(zipcode)
      return Rails.logger.error("Cannot get request code") unless request_code = get_request_code(zipcode)
      quotes = get_quotes(request_code)

      connection = Faraday.new("https://mortgageapi.zillow.com/getQuote") do |builder|
        builder.response :oj
        builder.adapter Faraday.default_adapter
        builder.params['partnerId'] = 'RD-CZMBMCZ'
        builder.params['includeRequest'] = true
        builder.params['includeLender'] = true
        builder.params['includeLenderRatings'] = true
        builder.params['includeLenderDisclaimers'] = true
        builder.params['includeLenderContactPhone'] = true
        builder.params['includeNote'] = true
      end

      quotes.map do |quote_id, _|
        response = connection.get do |request|
          request.params['quoteId'] = quote_id
        end
        standardlize_data(response.body)
      end
    end

    def self.get_quotes(request_code)
      connection = Faraday.new("https://mortgageapi.zillow.com/getQuotes") do |builder|
        builder.response :oj
        builder.adapter Faraday.default_adapter
        builder.params['partnerId'] = 'RD-CZMBMCZ'
        builder.params['requestRef.id'] = request_code
        builder.params['includeRequest'] = true
        builder.params['includeLenders'] = true
        builder.params['includeLendersRatings'] = true
        builder.params['includeLendersDisclaimers'] = true
        builder.params['sorts.0'] = 'SponsoredRelevance'
        builder.params['sorts.1'] = 'LenderRatings'
      end

      data = connection.get.body
      count = 0 # Fix bug on Heroku: data["quotes"] might be empty in first request.
      while count <= 10 && data["quotes"].empty?
        data = connection.get.body
        count += 1
      end
      data["quotes"]
    end

    def self.standardlize_data(lender_data)
      info = lender_data["lender"]
      quote = lender_data["quote"]
      lender_name = info["businessName"]
      nmls = info["nmlsLicense"]
      website = info["profileWebsiteURL"]
      apr = quote["apr"]
      monthly_payment = quote["monthlyPayment"]
      loan_amount = quote["loanAmount"]
      interest_rate = quote["rate"]
      lender_credit = quote["lenderCredit"]

      if quote["arm"]
        product = "#{quote["arm"]["fixedRateMonths"] / 12}/1 ARM"
        period = quote["arm"]["fixedRateMonths"]
      else
        product = "#{quote["termMonths"] / 12} year fixed"
        period = quote["termMonths"]
      end

      total_fee = 0
      fees = {}
      quote["fees"].each do |fee|
        fees[fee["name"]] = fee["amount"]
        total_fee += fee["amount"]
      end

      {
        lender_name: lender_name, nmls: nmls, website: website, apr: apr, monthly_payment: monthly_payment,
        loan_amount: loan_amount, interest_rate: interest_rate, product: product, total_fee: total_fee,
        fees: fees, down_payment: 100000, period: period, lender_credit: lender_credit
      }
    end
  end
end
