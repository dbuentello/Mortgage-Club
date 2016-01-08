module Crawler
  class Base
    attr_accessor :purpose, :crawler, :purchase_price, :credit_score,
                  :down_payment, :results

    def purchase?
      purpose == "purchase"
    end

    def set_up_crawler
      # crawler.driver.network_traffic
      # Capybara.register_driver :poltergeist do |app|
      #   Capybara::Poltergeist::Driver.new(app, {
      #     js_errors: false, timeout: 120, phantomjs_options: ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes']
      #   })
      # end

      Capybara.default_max_wait_time = 30
      Capybara::Session.new(:poltergeist)
    end

    def close_crawler
      crawler.driver.quit
    end
  end
end
