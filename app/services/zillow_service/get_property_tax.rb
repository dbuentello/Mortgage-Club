require 'capybara/poltergeist'

module ZillowService
  class GetPropertyTax
    def self.call(zpid = '19709750')
      #www.zillow.com/homes/19709750_zpid/
      browser = Capybara::Session.new(:poltergeist)
      browser.visit "http://www.zillow.com/homes/" + zpid + "_zpid"
      browser.find('h2', text: "Price / Tax History").click
      data = Nokogiri::HTML.parse(browser.html)
      count = 0

      while data.css('#hdp-tax-history table').empty?
        browser.find('h2', text: "Price / Tax History").click
        data = Nokogiri::HTML.parse(browser.html)
        count += 1
        break if count == 15
        p count
        sleep(5)
      end
      #data.css('#hdp-tax-history table tbody td')[0]
      #<td>2014</td>

      #data.css('#hdp-tax-history table tbody td')[1]
      #<td class="numeric">$5,813<span class="zsg-lg-hide"><span class="delta-value"><span class="inc">+15.6%</span></span></span>
      #</td>
    end
  end
end