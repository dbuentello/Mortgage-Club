require 'capybara'
require 'capybara/poltergeist'

module Crawler
  class LendaRates < Base
    include Capybara::DSL

    attr_accessor :zipcode, :property_value,
                  :down_payment, :monthly_payment,
                  :credit_score, :market_price, :balance

    def initialize(args)
      @purpose = args[:purpose]
      @zipcode = args[:zipcode]
      @property_value = args[:property_value]
      @down_payment = args[:down_payment]
      @credit_score = args[:credit_score]
      @monthly_payment = args[:monthly_payment].to_i
      @down_payment = args[:down_payment].to_i
      @purchase_price = args[:purchase_price].to_i
      @market_price = args[:market_price].to_i
      @balance = args[:balance].to_i
      @results = []
    end

    def call
      begin
        @crawler = set_up_crawler
        go_to_lenda
        fill_in_basic_options
        select_property_type
        select_property_usage
        fill_in_annual_income
        fill_in_monthly_debt
        crawler.execute_script("$('#quote_form').trigger('submit')")
        sleep(10)
        # crawler.find("span", text: "Hide advanced options").click
        get_rates
      rescue Exception => error
        byebug
      end
      # close_crawler
      byebug
      results
    end

    private

    def go_to_lenda
      crawler.visit("http://www.lenda.com/unified-rate-quotes")
    end

    def fill_in_basic_options
      crawler.find("label", text: "Refinance Purpose")
      first_mortgage_amount = 223423
      crawler.execute_script("$('#quote_first_mortgage_amount').val('#{first_mortgage_amount}')")
      # crawler.find("#quote_first_mortgage_amount").set(223423)
      value_of_home = 539922
      crawler.execute_script("$('#quote_value_of_home').val('#{value_of_home}')")
      # crawler.find("#quote_value_of_home").set(539922)
      zip_code = 95127
      crawler.execute_script("$('#quote_zip_code').val('#{zip_code}')")
      # crawler.find("#quote_zip_code").set(95127)
      credit_score = '720-739'
      crawler.execute_script("$('#quote_credit_rating_range').val('#{credit_score}')")
      crawler.execute_script("$('.simple_form').trigger('submit')")
    end

    def select_property_type
      property_type = 'Townhome'
      crawler.execute_script("$('#quote_type_of_home').val('#{property_type}')")
      # "Single-family"
      # "Condo"
      # "Townhome"
      # "2 Unit Home (Duplex)"
      # "3 Unit Home (Triplex)"
      # "4 Unit Home (Fourplex)"
      # "Mobile / Manufactured"
      # "Mixed Use"
    end

    def select_property_usage
      property_usage = "Second home"
      crawler.execute_script("$('#quote_occupancy_of_home').val('#{property_usage}')")
      # "Primary residence"
      # "Second home"
      # "Investment property"
    end

    def fill_in_annual_income
      annual_income = 1333500
      crawler.execute_script("$('#quote_annual_income').val(#{annual_income})")
      # byebug
    end

    def fill_in_monthly_debt
      monthly_debt = 30929
      crawler.execute_script("$('#quote_monthly_debt').val(#{monthly_debt})")
      # byebug
    end

    def get_rates
      crawler.find(".mixpanel-sort-preference-select").click
      crawler.find("li", text: "APR").click

      products = {
        "30-year fixed" => "30 year fixed",
        "20-year fixed" => "20 year fixed",
        "15-year fixed" => "15 year fixed",
        "10-year fixed" => "10 year fixed"
      }
      sleep(5)
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

    def get_rates_by_product(product)

      # get interest rate & apr

    end

    def programs?
      crawler.all("h3", text: "Sort according to your goals, then select your desired loan option.")[0].present?
    end
  end
end
