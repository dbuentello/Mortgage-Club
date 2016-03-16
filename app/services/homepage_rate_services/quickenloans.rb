module HomepageRateServices
  class Quickenloans
    include HTTParty

    def self.call
      html = get("http://www.quickenloans.com/mortgage-rates")
      doc = Nokogiri::HTML(html)

      apr_5_libor = 0
      apr_15_year = 0
      apr_30_year = 0

      doc.css(".rateTable__row").each do |rate|
        product_link = rate.css(".rateTable__product__link".freeze)
        next unless product_link.present?

        product_link_text = product_link.first.text
        apr = rate.css(".rateTable__product__apr".freeze).text.split("%".freeze).first.delete("(".freeze).to_f
        if product_link_text == "5-Year ARM".freeze
          apr_5_libor = apr.to_f
        elsif product_link_text == "15-Year Fixed".freeze
          apr_15_year = apr.to_f
        elsif product_link_text == "30-Year Fixed".freeze
          apr_30_year = apr.to_f
        else
          next
        end
      end

      {
        "apr_30_year" => apr_30_year == 0 ? nil : apr_30_year,
        "apr_15_year" => apr_15_year == 0 ? nil : apr_15_year,
        "apr_5_libor" => apr_5_libor == 0 ? nil : apr_5_libor
      }
    end
  end
end
