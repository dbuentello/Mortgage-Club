module MortgageRateServices
  class Quickenloans
    include HTTParty

    def self.call
      html = get("http://www.quickenloans.com/mortgage-rates")
      doc = Nokogiri::HTML(html)

      apr_5_libor = 0
      apr_15_year = 0
      apr_30_year = 0

      doc.css('.rateTable__row').each do |rate|
        product_link = rate.css('.rateTable__product__link')
        if product_link.present?
          product_link_text = product_link.first.text
          apr = rate.css('.rateTable__product__apr').text.split('%').first.delete('(').to_f
          if product_link_text == 'VA 5/1 ARM (1/1/5)'
            apr_5_libor = apr
          elsif product_link_text == '15-Year Fixed'
            apr_15_year = apr
          elsif product_link_text == '30-Year Fixed'
            apr_30_year = apr
          else
            next
          end
        end
      end

      {
        apr_30_year: apr_30_year,
        apr_15_year: apr_15_year,
        apr_5_libor: apr_5_libor
      }
    end
  end
end