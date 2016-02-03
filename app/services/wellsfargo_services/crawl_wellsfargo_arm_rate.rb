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

      begin
        go_to_wellsfargo
        fill_input_data
        click_calculate
        sleep(3)
        get_arm_rate
        close_crawler
      rescue => error
        crawler.save_and_open_page
      end

      arm_rate
    end

    def go_to_wellsfargo
      crawler.visit("https://www.wellsfargo.com/mortgage/rates/calculator/")
    end

    def fill_input_data
      crawler.find("#loanPurpose").find("option[value='#{loan_purpose}']").click
      crawler.find("#homeValue").set(home_value)
      crawler.find("#downPayment").set(down_payment)
      crawler.find("#propertyState").find("option[value='#{property_state}']").click
      crawler.find("#propertyCounty").find("option[value='#{property_county}']").click
    end

    def click_calculate
      crawler.find("input[name=submitButton]").click
    end

    def get_arm_rate
      rate_elements = crawler.all("#contentBody table tbody tr")

      rate_elements.each do |element|
        if element.text.include? "5/1 ARM View Details >"
          @arm_rate = element.find("td[headers='hdr3']").text.delete("%").to_f
        end
      end
    end

    def set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {js_errors: false, timeout: 60})
      end
      crawler = Capybara::Session.new(:poltergeist)
      crawler.driver.headers = {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X)"}
      crawler
      # Capybara::Session.new(:selenium)
    end

    def close_crawler
      crawler.driver.quit
    end
  end
end
