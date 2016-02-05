module HomepageRateServices
  class CrawlMortgageAprs
    def self.call
      mortgage_aprs = nil

      begin
        loan_tek = HomepageRateServices::LoanTek.call
        quicken_loans = HomepageRateServices::Quickenloans.call
        wellsfargo = HomepageRateServices::Wellsfargo.call

        mortgage_aprs = {
          "loan_tek" => loan_tek,
          "quicken_loans" => quicken_loans,
          "wellsfargo" => wellsfargo
        }
      ensure
        mortgage_aprs ||= default_aprs
      end

      mortgage_aprs
    end

    def self.default_aprs
      {
        "loan_tek" => {
          "apr_30_year" => "-",
          "apr_15_year" => "-",
          "apr_5_libor" => "-"
        },
        "quicken_loans" => {
          "apr_30_year" => "-",
          "apr_15_year" => "-",
          "apr_5_libor" => "-"
        },
        "wellsfargo" => {
          "apr_30_year" => "-",
          "apr_15_year" => "-",
          "apr_5_libor" => "-"
        },
        "updated_at" => Time.zone.now
      }
    end
  end
end
