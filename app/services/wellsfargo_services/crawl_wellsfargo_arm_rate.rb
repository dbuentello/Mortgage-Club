require "capybara"
require "capybara/poltergeist"

module WellsfargoServices
  class CrawlWellsfargoArmRate
    attr_accessor :loan_purpose, :home_value, :down_payment, :property_state, :property_county, :crawler, :arm_rate

    def initialize(args)
      @loan_purpose = args[:loan_purpose]
      @home_value = args[:home_value]
      @down_payment = args[:down_payment]
      @property_state = args[:property_state]
      @property_county = args[:property_county]
      @crawler = set_up_crawler
      @arm_rate = 0
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
      get_arm_rate
      close_crawler

      arm_rate
    end

    def go_to_wellsfargo
      crawler.visit("https://www.wellsfargo.com/mortgage/")
    end

    def fill_input_data
      crawler.select(loan_purpose, from: "Loan Purpose")
      crawler.fill_in("Home Value", with: home_value)
      crawler.fill_in("Down Payment", with: down_payment)
      crawler.select(property_state, from: "State")
      crawler.select(property_county, from: "County")
    end

    def click_calculate
      crawler.find("input[name=submitButton]").click
    end

    def get_arm_rate
      rate_elements = crawler.all("#contentBody table tbody tr")

      rate_elements.each do |element|
        if element.text.include? "5/1 ARM"
          @arm_rate = element.find("td[headers='hdr3']").text.delete("%").to_f
          break
        end
      end
    end

    def set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
          js_errors: true, timeout: 40, phantomjs_options: ["--load-images=no", "--ignore-ssl-errors=yes"]
        })
      end

      Capybara.default_max_wait_time = 30
      Capybara::Session.new(:poltergeist)
      # Capybara::Session.new(:selenium)
    end

    def close_crawler
      crawler.driver.quit
    end
  end
end
