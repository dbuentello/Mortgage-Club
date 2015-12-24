require 'capybara'
require 'capybara/poltergeist'

module Crawler
  class CrawlGoogleRates
    include Capybara::DSL

    attr_accessor :purpose, :zipcode, :property_value,
                  :down_payment, :credit_score, :years,
                  :monthly_payment, :down_payment, :purchase_price,
                  :credit_score, :market_price, :balance, :is_refinance,
                  :results, :crawler

    def initialize(args)
      @purpose = args[:purpose]
      @zipcode = args[:zipcode]
      @property_value = args[:property_value]
      @down_payment = args[:down_payment]
      @credit_score = args[:credit_score]
      @years = args[:years]
      @monthly_payment = args[:monthly_payment].to_i
      @down_payment = args[:down_payment].to_i
      @purchase_price = args[:purchase_price].to_i
      @credit_score = args[:credit_score]
      @market_price = args[:market_price].to_i
      @balance = args[:balance].to_i
      @is_refinance = args[:is_refinance]
      @crawler = set_up_crawler
      @results = []
    end

    def call
      go_to_google_mortgage
      select_purpose_of_mortgage
      if is_refinance
        fill_in_details_with_refinance
      else
        fill_in_details_with_purchase
      end

      select_years
      select_monthly_payment
      get_recommend_rates
      get_rates_with_more_criteria
      close_crawler
      results
    end

    private

    def go_to_google_mortgage
      crawler.visit("http://www.google.com/compare/mortgages")
      crawler.find("h1", text: "Need help finding the right mortgage?")
      crawler.find("._emf button._ioi", text: "GUIDED SEARCH").click
    end

    def select_purpose_of_mortgage
      crawler.find("span", text: "Please select").click
      if is_refinance
        crawler.find(".cFXbRFABN7X__item-content", text: "Refinance").click
      else
        crawler.find(".cFXbRFABN7X__item-content", text: "Purchase").click
      end
      crawler.find("._Qlf input[type=tel]").set(zipcode)
      crawler.find("._sZh", text: "NEXT").click
    end

    def fill_in_details_with_purchase
      crawler.find("h1", text: "Now tell us a few more details...")
      crawler.find("._qni ._N4g input[type=tel]").set(purchase_price)
      crawler.find("._mni ._N4g input[type=tel]").set(down_payment)
      select_credit_score
      crawler.find("._sZh", text: "NEXT").click
    end

    def fill_in_details_with_refinance
      crawler.find("h1", text: "Now tell us a few more details...")
      crawler.find("._qni ._N4g input[type=tel]").set(market_price)
      crawler.find("._mni ._N4g input[type=tel]").set(balance)
      select_credit_score
      crawler.find("._sZh", text: "NEXT").click
    end

    def select_years
      crawler.find("h1", text: "How long do you plan on owning the property?")
      if years > 16
        crawler.all("._X9h span")[2].click
      elsif years > 6
        crawler.all("._X9h span")[1].click
      else
        crawler.all("._X9h span")[0].click
      end
      crawler.find("._sZh", text: "NEXT").click
    end

    def select_monthly_payment
      selected_span = 0
      crawler.find("h1", text: "How much can you pay each month?")
      data = Nokogiri::HTML.parse(crawler.html)
      data.css("._X9h span").each_with_index do |span, index|
        min_value = span.text.split(" - ").first.gsub(/[^0-9\.]/, "").to_f
        max_value = span.text.split(" - ").last.gsub(/[^0-9\.]/, "").to_f

        if min_value == max_value
          selected_span = index
          break
        end

        if min_value < monthly_payment && monthly_payment < max_value
          selected_span = index
          break
        end
      end
      crawler.all("._X9h span")[selected_span].click
      crawler.find("._sZh", text: "NEXT").click
    end

    def select_credit_score
      crawler.find("span", text: "700-719 (Good)").click # to display dropdown menu
      score = 759
      offset = 0
      while score > 620
        break if credit_score > score
        score -= 20
        offset += 1
      end
      crawler.all(".cFXbRFABN7X__item-content")[offset].click
    end

    def get_recommend_rates
      crawler.find("span", text: "RECOMMENDED")
      data = Nokogiri::HTML.parse(crawler.html)
      get_lowest_rates(data)
    end

    def get_rates_with_more_criteria
      crawler.find("._gki span", text: "MORE CRITERIA").click
      crawler.find("._Y2h", text: "How many years will you own the home?")
      crawler.find("._oni input[type=tel]").set(5)
      crawler.find("button", text: "UPDATE").click
      crawler.find(".card-heading div", text: "Cheapest over 5-year period")
      data = Nokogiri::HTML.parse(crawler.html)
      get_lowest_rates(data)
    end

    def get_lowest_rates(data)
      data.css("._Kmf")[0].css("._NNf").each do |mortgage|
        results << {
          lender_name: mortgage.css("._uyi ._zVf").text,
          product: mortgage.css("._Hyi ._BWf").text.strip,
          interest_rate: mortgage.css("._Hyi ._BVg span")[0].text.gsub(/[^0-9\.]/, "").to_f / 100,
          apr: mortgage.css("._Hyi ._ZVg span")[0].text.gsub(/[^0-9\.]/, "").to_f / 100,
          down_payment: down_payment
        }
      end
    end

    def close_crawler
      crawler.driver.quit
    end

    def set_up_crawler
      # crawler.driver.network_traffic
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
          js_errors: true, timeout: 60, inspector: true, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes']
        })
      end

      Capybara.default_max_wait_time = 60
      Capybara::Session.new(:poltergeist)
    end
  end
end
