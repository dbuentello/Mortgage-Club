require 'capybara'
require 'capybara/poltergeist'

module ZillowService
  class CrawlZillowRates
    include HTTParty
    include Capybara::DSL

    attr_accessor :zipcode, :purchase_price, :down_payment, :annual_income, :number_of_results, :crawler

    def initialize(args)
      @zipcode = args[:zipcode]
      @purchase_price = args[:purchase_price]
      @down_payment = args[:down_payment]
      @annual_income = args[:annual_income]
      @number_of_results = args[:number_of_results]
    end

    def call
      raise "zipcode is missing!" unless zipcode.present?

      @crawler = set_up_crawler
      request_code = get_request_code(zipcode, purchase_price, down_payment, annual_income)
      quotes = get_quotes(request_code)
      close_crawler
      get_rates(quotes)
    end

    def set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {js_errors: false, timeout: 60})
      end
      crawler = Capybara::Session.new(:poltergeist)
      crawler.driver.headers = {'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)"}
      crawler
    end

    def get_request_code(zipcode, purchase_price, down_payment, annual_income)
      user_session_id = "userSessionId=2de70907-6e58-45f6-a7e8-dc2efb69e261" # hardcode session ID
      url =           "https://mortgageapi.zillow.com/submitRequest?"\
                      "property.type=SingleFamilyHome&property.use=Primary"\
                      "&property.zipCode=#{zipcode}&property.value=#{purchase_price}"\
                      "&borrower.creditScoreRange=R_760_&borrower.annualIncome=#{annual_income}"\
                      "&borrower.monthlyDebts=0&borrower.selfEmployed=false"\
                      "&borrower.hasBankruptcy=false&borrower.hasForeclosure=false"\
                      "&desiredPrograms.0=Fixed30Year&desiredPrograms.1=Fixed15Year"\
                      "&desiredPrograms.2=ARM5&desiredPrograms.3=Fixed20Year"\
                      "&desiredPrograms.4=Fixed10Year&desiredPrograms.5=ARM7"\
                      "&desiredPrograms.6=ARM3&purchase.downPayment=#{down_payment}"\
                      "&purchase.firstTimeBuyer=false&purchase.newConstruction=false"\
                      "&partnerId=RD-CZMBMCZ&#{user_session_id}"
      crawler.visit url
      request_code = crawler.text.split('":"').last.chomp('"}')
    end

    def get_rates(quotes)
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

      quote_id_str = 'quoteId'.freeze
      quotes.map! do |quote_id, _|
        response = connection.get do |request|
          request.params[quote_id_str] = quote_id
        end
        standardlize_data(response.body, down_payment)
      end
    end

    def get_quotes(request_code)
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

      return [] if data["error"].present?

      count = 0 # Fix bug on Heroku: data["quotes"] might be empty in first request.

      while count <= 10 && data["quotes".freeze].empty?
        data = connection.get.body
        count += 1
      end

      @number_of_results ||= data["quotes"].length
      quotes = data["quotes"].sort_by { |_, value| value["apr".freeze] }
      quotes.take(@number_of_results)
    end

    def close_crawler
      crawler.driver.quit
    end

    def standardlize_data(lender_data, down_payment)
      info = lender_data["lender".freeze]
      quote = lender_data["quote".freeze]
      lender_name = info["businessName".freeze]
      nmls = info["nmlsLicense".freeze]
      website = info["profileWebsiteURL".freeze]
      apr = quote["apr".freeze]
      monthly_payment = quote["monthlyPayment".freeze]
      loan_amount = quote["loanAmount".freeze]
      interest_rate = quote["rate".freeze].to_f / 100
      lender_credit = quote["lenderCredit".freeze]

      if quote["arm".freeze]
        product = "#{quote["arm".freeze]["fixedRateMonths"] / 12}/1 ARM"
        period = quote["arm"]["fixedRateMonths".freeze]
      else
        product = "#{quote["termMonths"] / 12} year fixed"
        period = quote["termMonths".freeze]
      end

      total_fee = 0
      fees = {}

      return {} unless quote["fees".freeze]

      quote["fees"].each do |fee|
        fees[fee["name"].freeze] = fee["amount".freeze]
        total_fee += fee["amount"]
      end

      lender_credit = lender_credit.present? ? lender_credit : 0
      total_closing_cost = total_fee - lender_credit

      Rails.logger.error("Period was nil: #{lender_data}") unless period

      {
        lender_name: lender_name, nmls: nmls, website: website, apr: apr, monthly_payment: monthly_payment,
        loan_amount: loan_amount, interest_rate: interest_rate, product: product, total_fee: total_fee,
        fees: fees, down_payment: down_payment, period: period, lender_credit: lender_credit,
        total_closing_cost: total_closing_cost
      }
    end
  end
end