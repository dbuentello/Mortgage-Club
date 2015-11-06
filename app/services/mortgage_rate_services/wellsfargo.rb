module MortgageRateServices
  class Wellsfargo
    include HTTParty

    def self.call
      html = get("https://www.wellsfargo.com/mortgage/rates")
      doc = Nokogiri::HTML(html)

      apr_5_libor = 0
      apr_15_year = 0
      apr_30_year = 0

      doc.css('#productName').each do |rate|
        if rate.text == '5/1 ARM FHA' && rate.at_css('a').attr('href') == '/mortgage/rates/purchase-assumptions?prod=5'
          apr_5_libor = rate.parent.css('td').last.text.delete('%').to_f
        elsif rate.text == '15-Year Fixed Rate' && rate.at_css('a').attr('href') == '/mortgage/rates/purchase-assumptions?prod=3'
          apr_15_year = rate.parent.css('td').last.text.delete('%').to_f
        elsif rate.text == '30-Year Fixed Rate' && rate.at_css('a').attr('href') == '/mortgage/rates/purchase-assumptions?prod=1'
          apr_30_year = rate.parent.css('td').last.text.delete('%').to_f
        else
          next
        end
      end

      {
        "apr_30_year" => apr_30_year,
        "apr_15_year" => apr_15_year,
        "apr_5_libor" => apr_5_libor
      }
    end
  end
end