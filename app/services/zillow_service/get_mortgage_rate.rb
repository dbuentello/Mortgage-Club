require 'capybara'
require 'capybara/poltergeist'

module ZillowService
  class GetMortgageRate
    include Capybara::DSL
    MAX_PAGE = 3

    def self.call(zipcode)
      return unless zipcode
      Rails.cache.fetch("mortgage-rates-#{zipcode}-#{Time.zone.now.to_date.to_s}", expires_in: 1.day) do
        zipcode = zipcode[0..4] if zipcode.length > 5
        set_up_crawler
        fill_in_form(zipcode)
        get_lenders
      end
    end

    private

    def self.set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {js_errors: false})
      end
      @session = Capybara::Session.new(:poltergeist)
      @session.driver.headers = {
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X)"
      }
    end

    def self.fill_in_form(zipcode)
      @session.visit "http://www.zillow.com/mortgage-rates/"
      @session.find('a', text: "Advanced").click
      @session.select('Purchase', from: 'Loan purpose')
      @session.fill_in('ZIP code', with: zipcode)
      @session.fill_in('Purchase price', with: '500000')
      @session.fill_in('Down payment', with: '100000')
      @session.select('760 and above', from: 'Credit score')
      @session.fill_in('Monthly debts', with: '800')
      @session.fill_in('Annual income', with: '200000')
      @session.select('Single family home', from: 'Property type')
      @session.select('Primary residence', from: 'How is home used?')
      @session.select('No', from: 'First-time buyer?')
      @session.select('No', from: 'New construction?')
      @session.click_on('Get rates')
      sleep(15)
    end

    def self.get_lenders
      begin
        data = Nokogiri::HTML.parse(@session.html)
        lenders = []
        return if no_result?(data)
        buttons = @session.all(".zmm-quote-card-button")
        data.css(".zmm-pagination-list li").each_with_index do |_, index|
          break if index >= MAX_PAGE
          if index != 0
            @session.find(".zmm-pagination-list li a", text: index).click
            sleep(1)
            data = Nokogiri::HTML.parse(@session.html)
          end
          buttons = @session.all(".zmm-quote-card-button")
          lenders << buttons.map do |button|
            button.click
            sleep(1)
            data = Nokogiri::HTML.parse(@session.html)
            lender_name = data.css(".zmm-quote-details-content .zsg-h1").text
            nmls = data.css(".zmm-qdp-subtitle-list li")[0].text.gsub(/[^0-9\.]/,'')
            #loan details
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
              loan_details[info_name]  = value

              next if ["Loan product", "Quote ID", "Date submitted"].include? info_name

              if value.include?("(")
                loan_details[info_name] = ("-" << value.gsub(/[^0-9\.]/,'')).to_f
              else
                loan_details[info_name] = value.gsub(/[^0-9\.]/,'').to_f
              end
            end

            duration = data.css(".zmm-qdp-loan-details-section .zmm-qdp-loan-product").text.gsub(/[^0-9\.]/,'').to_f
            rate = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[1].css("td")[0].text.gsub(/[^0-9\.]/,'').to_f
            apr = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[2].css("td")[0].text.gsub(/[^0-9\.]/,'').to_f
            payment = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[3].css("td")[0].text.gsub(/[^0-9\.]/,'').to_f
            loan_amount = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[4].css("td")[0].text.gsub(/[^0-9\.]/,'').to_f
            down_payment = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[5].css("td")[0].text.gsub(/[^0-9\.]/,'').to_f
            quote_id = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[6].css("td")[0].text
            date_submitted = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[0].css("tr")[7].css("td")[0].text
            rate_lock = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[1].css("tr")[0].css("td")[0].text
            due_in = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[1].css("tr")[1].css("td")[0].text
            prepayment_penalty = data.css(".zmm-qdp-loan-details-section .zmm-table_tooltips")[1].css("tr")[2].css("td")[0].text
            fees = {
              "Loan origination fee" => 0,
              "Underwriting fee" => 0,
              "Appraisal fee" => 0,
              "Lender credit" => 0,
              "Tax service fee" => 0,
              "Credit report fee" => 0,
              "Total Estimated Fees" => 0
            }
            #fees
            data.css(".zmm-quote-details-fees .zmm-table_tooltips tr").each do |tr|
              fee_name = tr.css("th").text
              fee = tr.css("td").text
              if fee.include?("(")
                fees[fee_name] = ("-" << fee.gsub(/[^0-9\.]/,'')).to_f
              else
                fees[fee_name] = fee.gsub(/[^0-9\.]/,'').to_f
              end
            end
            @session.find(".zsg-icon-x-thin ").click
            {
              lender: {name: lender_name, nmls: nmls},
              loan: loan_details,
              fees: fees
            }
          end
        end
      rescue StandardError => error
        Rails.logger.error error.message
      end
      lenders.flatten
    end

    def self.no_result?(data)
      data.css(".zmm-loan-request-errors").text != ""
    end
  end
end
