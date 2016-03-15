require 'capybara'
require 'capybara/poltergeist'

module HomepageRateServices
  class Chase
    def self.call
      self.set_up_crawler
      count = 0
      @session.visit("https://www.chase.com/mortgage/mortgage-rates")
      doc = Nokogiri::HTML(@session.html)

      while doc.css("#rates-assumptions-table").empty? && count < 5
        @session.visit("https://www.chase.com/mortgage/mortgage-rates")
        doc = Nokogiri::HTML(@session.html)
        count += 1
        sleep(3)
      end

      apr_5_libor = 0
      apr_15_year = 0
      apr_30_year = 0

      table_data = doc.at_css("#rates-assumptions-table")
      if table_data.present?
        apr_30_year = table_data.css('tr')[2].css('td')[2].text.delete('%').to_f
        apr_15_year = table_data.css('tr')[4].css('td')[2].text.delete('%').to_f
        apr_5_libor = table_data.css('tr')[10].css('td')[2].text.delete('%').to_f
      end

      {
        "apr_30_year" => apr_30_year,
        "apr_15_year" => apr_15_year,
        "apr_5_libor" => apr_5_libor
      }
    end

    def self.set_up_crawler
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
      end
      @session = Capybara::Session.new(:poltergeist)
    end
  end
end