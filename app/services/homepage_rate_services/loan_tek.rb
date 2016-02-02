module HomepageRateServices
  class LoanTek
    def self.call
      # @rates = ZillowService::CrawlZillowRates.new({
      #   zipcode: 94103,
      #   purchase_price: 500000,
      #   down_payment: 100000,
      #   annual_income: 200000
      # }).call

      {
        "apr_30_year" => 0,
        "apr_15_year" => 0,
        "apr_5_libor" => 0
      }
    end
  end
end
