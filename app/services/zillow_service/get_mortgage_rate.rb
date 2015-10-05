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
      p ">>>> lenders:"
      p lenders
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

      response = HTTParty.get("https://mortgageapi.zillow.com/getQuotes?"\
                              "partnerId=RD-CZMBMCZ&requestRef.id=#{request_code}"\
                              "&includeRequest=true&includeLenders=true"\
                              "&includeLendersRatings=true&includeLendersDisclaimers=true"\
                              "&sorts.0=SponsoredRelevance&sorts.1=LenderRatings")
      data = JSON.parse(response.body)
      data["quotes"] ||= []
      lenders = []
      count = 0

      data["quotes"].each do |quote_id, _|
        response = HTTParty.get("https://mortgageapi.zillow.com/getQuote?"\
                                "partnerId=RD-CZMBMCZ&quoteId=#{quote_id}"\
                                "&includeRequest=true&includeLender=true"\
                                "&includeLenderRatings=true&includeLenderDisclaimers=true"\
                                "&includeLenderContactPhone=true&includeNote=true")
        lender_data = JSON.parse(response.body)
        info = lender_data["lender"]
        quote = lender_data["quote"]
        lender_name = info["businessName"]
        nmls = info["nmlsLicense"]
        website = info["profileWebsiteURL"]
        apr = quote["apr"]
        monthly_payment = quote["monthlyPayment"]
        loan_amount = quote["loanAmount"]
        interest_rate = quote["rate"]
        if quote["arm"]
          product = "#{quote["arm"]["fixedRateMonths"] / 12}/1 ARM"
        else
          product = "#{quote["termMonths"] / 12} year fixed"
        end
        total_fee = 0
        fees = {}
        quote["fees"].map do |fee|
          fees[fee["name"]] = fee["amount"]
          total_fee += fee["amount"]
        end
        count += 1
        lenders << {
          lender_name: lender_name, nmls: nmls, website: website, apr: apr, monthly_payment: monthly_payment,
          loan_amount: loan_amount, interest_rate: interest_rate, product: product, total_fee: total_fee, fees: fees, down_payment: 100000
        }
      end
      lenders
    end
  end
end
