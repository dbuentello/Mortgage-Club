module HomepageRateServices
  class Wellsfargo
    def self.call
      rates = WellsfargoServices::CrawlWellsfargoRates.new(
        loan_purpose: "Purchase",
        home_value: 400000,
        down_payment: 80000,
        property_state: "CA",
        property_county: "San Francisco"
      ).call

      {
        "apr_30_year" => rates[:apr_30_year],
        "apr_15_year" => rates[:apr_15_year],
        "apr_5_libor" => rates[:apr_5_libor]
      }
    end
  end
end
