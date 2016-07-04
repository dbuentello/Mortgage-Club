require "capybara"
require "capybara/poltergeist"

module WellsfargoServices
  class CrawlWellsfargoRates
    attr_accessor :loan_purpose, :home_value, :down_payment, :property_state, :property_county, :crawler, :rates

    def initialize(args)
      @loan_purpose = args[:loan_purpose]
      @home_value = args[:home_value]
      @down_payment = args[:down_payment]
      @property_state = args[:property_state]
      @property_county = args[:property_county]
      @crawler = set_up_crawler
      @rates = {
        apr_30_year: 0,
        apr_15_year: 0,
        apr_5_libor: 0
      }
    end

    def call
      raise "loan purpose is missing!" unless loan_purpose.present?
      raise "home value is missing!" unless home_value.present?
      raise "down payment is missing!" unless down_payment.present?
      raise "property state is missing!" unless property_state.present?
      raise "property county is missing!" unless property_county.present?

      go_to_wellsfargo
      fill_input_data
      click_calculate
      sleep(3)
      get_rates
      close_crawler

      rates
    end

    def go_to_wellsfargo
      crawler.visit("https://www.wellsfargo.com/mortgage/")
    end

    def fill_input_data
      crawler.select(loan_purpose, from: "Loan Purpose")
      crawler.fill_in("Home Value", with: home_value)
      crawler.fill_in("Down Payment", with: down_payment)
      crawler.select(property_state, from: "State")
      crawler.execute_script("changeCounties()")
      crawler.select(property_county, from: "County")
    end

    def click_calculate
      crawler.find("input[name=submitButton]").click
    end

    def get_rates
      rate_elements = crawler.all("#contentBody table tbody tr")

      rate_elements.each do |element|
        if element.text.index("5/1 ARM").present? && rates[:apr_5_libor] == 0
          @rates[:apr_5_libor] = element.find("td[headers='hdr3']").text.delete("%").to_f
        elsif element.text.index("30-Year Fixed Rate").present? && rates[:apr_30_year] == 0
          @rates[:apr_30_year] = element.find("td[headers='hdr3']").text.delete("%").to_f
        elsif element.text.index("15-Year Fixed Rate").present? && rates[:apr_15_year] == 0
          @rates[:apr_15_year] = element.find("td[headers='hdr3']").text.delete("%").to_f
        end
      end
    end

    def set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(
          app,
          js_errors: true,
          timeout: 40,
          phantomjs_options: ["--load-images=no", "--ignore-ssl-errors=yes"]
        )
      end

      Capybara.default_max_wait_time = 30
      Capybara::Session.new(:poltergeist)
    end

    def close_crawler
      crawler.driver.quit
    end
  end
end
