module HomepageRateServices
  class Wellsfargo
    include HTTParty

    def self.call
      apr_5_libor = 0
      apr_30_year = 0
      apr_15_year = 0

      html = get("https://www.wellsfargo.com/mortgage/rates", verify: false)
      doc = Nokogiri::HTML(html)

      doc.css("#productName").each do |rate|
        if rate.text == "5/1 ARM FHA".freeze && rate.at_css("a".freeze).attr("href".freeze) == "/mortgage/rates/purchase-assumptions?prod=5".freeze
          apr_5_libor = rate.parent.css('td'.freeze).last.text.delete('%'.freeze).to_f
        elsif rate.text == "15-Year Fixed Rate".freeze && rate.at_css("a").attr("href") == "/mortgage/rates/purchase-assumptions?prod=3".freeze
          apr_15_year = rate.parent.css("td").last.text.delete("%").to_f
        elsif rate.text == "30-Year Fixed Rate".freeze && rate.at_css("a").attr("href") == "/mortgage/rates/purchase-assumptions?prod=1".freeze
          apr_30_year = rate.parent.css("td").last.text.delete("%").to_f
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