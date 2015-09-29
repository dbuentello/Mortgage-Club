require 'capybara'
require 'capybara/poltergeist'

module ZillowService
  class GetMortgageRate
    include Capybara::DSL
    MAX_PAGE = 3

    def self.call(zipcode)
      return unless zipcode
      # Rails.cache.fetch("mortgage-rates-#{zipcode}-#{Time.zone.now.to_date.to_s}", expires_in: 12.hour) do
        zipcode = zipcode[0..4] if zipcode.length > 5
        set_up_crawler
        get_lenders(zipcode)
      # end
    end

    private

    def self.set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {js_errors: false})
      end
      @session = Capybara::Session.new(:poltergeist)
      # @session.driver.headers = { 'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
    end

    def self.get_request_code(zipcode)
      user_session_id = "userSessionId=2de70907-6e58-45f6-a7e8-dc2efb69e261" # hardcode session ID
      @session.visit "https://mortgageapi.zillow.com/submitRequest?property.type=SingleFamilyHome&property.use=Primary&property.zipCode=#{zipcode}&property.value=500000&borrower.creditScoreRange=R_760_&borrower.annualIncome=200000&borrower.monthlyDebts=0&borrower.selfEmployed=false&borrower.hasBankruptcy=false&borrower.hasForeclosure=false&desiredPrograms.0=Fixed30Year&desiredPrograms.1=Fixed15Year&desiredPrograms.2=ARM5&purchase.downPayment=100000&purchase.firstTimeBuyer=false&purchase.newConstruction=false&partnerId=RD-CZMBMCZ&#{user_session_id}"
      request_code = @session.text.split('":"').last.chomp('"}')
      Rails.logger.info request_code
      request_code
    end

    def self.get_lenders(zipcode)
      begin
        return Rails.logger.error("Cannot get request code") unless request_code = get_request_code(zipcode)
        Rails.logger.info "visit to get rates"
        @session.visit("http://www.zillow.com/mortgage-rates/#request=#{request_code}")
        data = Nokogiri::HTML.parse(@session.html)
        attempt = 0
        while data.css(".zmm-pagination-list li").empty? && attempt < 6
          sleep(5)
          attempt += 1
          data = Nokogiri::HTML.parse(@session.html)
        end
        lenders = []
        return if no_result?(data)

        data.css(".zmm-pagination-list li").each_with_index do |_, index|
          Rails.logger.info "page #{index + 1}"
          break if index > MAX_PAGE
          if index != 0
            @session.find(".zmm-pagination-list li a", text: index).click
            sleep(1)
            data = Nokogiri::HTML.parse(@session.html)
          end
          buttons = @session.all(".zmm-quote-card-button")
          lenders << buttons.map do |button|
            data = Nokogiri::HTML.parse(@session.html)
            attempt = 0
            nmls = ''
            button.click
            while (data.css(".zmm-qdp-subtitle-list li").empty? && attempt < 6)
              sleep(5)
              attempt += 1
              data = Nokogiri::HTML.parse(@session.html)
            end
            lender_name = data.css(".zmm-quote-details-content .zsg-h1").text
            if data.css(".zmm-qdp-subtitle-list li").empty?
              Rails.logger.error "cannot get nmls"
            else
              nmls = data.css(".zmm-qdp-subtitle-list li")[0].text.gsub(/[^0-9\.]/,'')
            end
            @session.find(".zsg-icon-x-thin ").click
            result = {
              lender: {name: lender_name, nmls: nmls},
              loan: get_loan_details(data),
              fees: get_lender_fees(data)
            }
            Rails.logger.info "result: #{result}"
            result
          end
        end
        return lenders.flatten
      rescue StandardError => error
        Rails.logger.error error.message
      end
    end

    def self.get_lender_fees(data)
      fees = {
        "Loan origination fee" => 0,
        "Underwriting fee" => 0,
        "Appraisal fee" => 0,
        "Lender credit" => 0,
        "Tax service fee" => 0,
        "Credit report fee" => 0,
        "Total Estimated Fees" => 0
      }
      data.css(".zmm-quote-details-fees .zmm-table_tooltips tr").each do |tr|
        fee_name = tr.css("th").text
        fee = tr.css("td").text
        if fee.include?("(")
          fees[fee_name] = ("-" << fee.gsub(/[^0-9\.]/,'')).to_f
        else
          fees[fee_name] = fee.gsub(/[^0-9\.]/,'').to_f
        end
      end
      fees
    end

    def self.get_loan_details(data)
      loan_details = {
        "Interest rate" => 0,
        "APR" => 0,
        "Payment (principal & interest)" => 0,
        "Loan amount" => 0,
        "Down payment" => 0,
        "Base loan amount" => 0,
        "Total loan amount" => 0,
        "FHA upfront MI premium" => 0,
        "Loan product" => "",
        "Quote ID" => "",
        "Date submitted" => ""
      }
      data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips tr").each do |tr|
        info_name = tr.css("th").text
        value = tr.css("td").text
        if ["Loan product", "Quote ID", "Date submitted"].include? info_name
          loan_details[info_name]  = value.strip!
          next
        end

        if value.include?("(")
          loan_details[info_name] = ("-" << value.gsub(/[^0-9\.]/,'')).to_f
        else
          loan_details[info_name] = value.gsub(/[^0-9\.]/,'').to_f
        end
      end
      loan_details
    end

    def self.no_result?(data)
      data.css(".zmm-loan-request-errors").text != ""
    end
  end
end
