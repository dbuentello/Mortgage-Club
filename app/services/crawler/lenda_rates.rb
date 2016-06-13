# a crawler for lenda rates.
require 'capybara'
require 'capybara/poltergeist'

module Crawler
  class LendaRates < Base
    attr_accessor :zipcode, :usage, :annual_income,
                  :down_payment, :monthly_debt, :property_type,
                  :credit_score, :market_price, :balance

    def initialize(args)
      @zipcode = args[:zipcode]
      @market_price = args[:market_price].to_i
      @balance = args[:balance].to_i
      @credit_score = args[:credit_score]
      @property_type = args[:property_type]
      @usage = args[:usage]
      @annual_income = args[:annual_income]
      @monthly_debt = args[:monthly_debt]
      @results = []
    end

    def call
      @crawler = set_up_crawler
      begin
        go_to_lenda
        fill_in_basic_options
        submit_form
        if programs?
          select_property_type
          select_property_usage
          fill_in_annual_income
          fill_in_monthly_debt
          submit_form
          sort_rates
          get_rates
        end
      rescue Timeout::Error, Capybara::ElementNotFound => error
        Rails.logger.error("Cannot get rates from Lenda: #{error.message}")
      end
      close_crawler
      results
    end

    private

    def go_to_lenda
      crawler.visit("http://www.lenda.com/unified-rate-quotes")
    end

    def fill_in_basic_options
      crawler.find("label", text: "Refinance Purpose")
      crawler.execute_script("$('#quote_first_mortgage_amount').val('#{balance}')")
      crawler.execute_script("$('#quote_value_of_home').val('#{market_price}')")
      crawler.execute_script("$('#quote_zip_code').val('#{zipcode}')")
      crawler.execute_script("$('#quote_credit_rating_range').val('#{get_credit_score}')")
    end

    def select_property_type
      types = {
        "sfh" => "Single-family",
        "duplex" => "2 Unit Home (Duplex)",
        "triplex" => "3 Unit Home (Triplex)",
        "fourplex" => "4 Unit Home (Fourplex)",
        "condo" => "Condo"
      }
      crawler.execute_script("$('#quote_type_of_home').val('#{types[property_type]}')")
    end

    def select_property_usage
      usages = {
        "primary_residence" => "Primary residence",
        "vacation_home" => "Second home",
        "rental_property" => "Investment property"
      }
      crawler.execute_script("$('#quote_occupancy_of_home').val('#{usages[usage]}')")
    end

    def fill_in_annual_income
      crawler.execute_script("$('#quote_annual_income').val(#{annual_income})")
    end

    def fill_in_monthly_debt
      return unless monthly_debt

      crawler.execute_script("$('#quote_monthly_debt').val(#{monthly_debt})")
    end

    def submit_form
      crawler.execute_script("$('#quote_form').trigger('submit')")
      sleep(10)
    end

    def sort_rates
      crawler.find(".mixpanel-sort-preference-select").click
      crawler.find("li", text: "APR").click
      sleep(6)
    end

    def get_rates
      products = {
        "30-year fixed" => "30 year fixed",
        "20-year fixed" => "20 year fixed",
        "15-year fixed" => "15 year fixed",
        "10-year fixed" => "10 year fixed"
      }

      products.each do |key, value|
        next unless programs?
        crawler.find(".js-type-of-loan-select").click
        crawler.find("li", text: key).click
        sleep(6)
        data = Nokogiri::HTML.parse(crawler.html)
        results << {
          interest_rate: data.css(".rate-param")[1].css(".header").text.gsub(/[^0-9\.]/, "").to_f / 100,
          apr: data.css(".rate-param")[1].css(".subheader").text.gsub(/[^0-9\.]/, "").to_f,
          down_payment: down_payment,
          lender_name: "Lenda",
          product: value,
          total_fee: get_total_fee(data)
        }
      end
    end

    def get_total_fee(data)
      prepaid_items = data.css(".rate-detail-table")[0].css("tr")[4].text.gsub(/[^0-9\.]/, "").to_f
      total_closing_costs = data.css(".rate-detail-table")[0].css("tr")[5].text.gsub(/[^0-9\.]/, "").to_f
      total_closing_costs - prepaid_items
    end

    def get_credit_score
      return "740+" if credit_score >= 740

      score = 739
      # selected_score = "740+"
      while score > 620
        break if credit_score > score
        score -= 20
      end
      "#{score - 19}-#{score}"
    end

    def programs?
      crawler.all("h3", text: "Sort according to your goals, then select your desired loan option.")[0].present?
    end
  end
end
