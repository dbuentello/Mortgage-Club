module HomepageRateServices
  class CrawlMortgageAprs
    def self.call
      return default_aprs unless Rails.env.production?

      loan_tek = HomepageRateServices::LoanTek.call
      quicken_loans = HomepageRateServices::Quickenloans.call
      wellsfargo = HomepageRateServices::Wellsfargo.call

      mortgage_aprs = {
        "loan_tek" => loan_tek,
        "quicken_loans" => quicken_loans,
        "wellsfargo" => wellsfargo,
        "updated_at" => Time.zone.now
      }

      mortgage_aprs
    end

    def self.default_aprs
      {
        "loan_tek" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "quicken_loans" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "wellsfargo" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "updated_at" => Time.zone.now
      }
    end
  end
end
