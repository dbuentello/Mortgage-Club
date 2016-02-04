module HomepageRateServices
  class CrawlMortgageAprs
    def self.call(refresh_cache = false)
      # return default_aprs unless Rails.env.production?

      cache_key = "mortgage-apr"

      if !refresh_cache && mortgage_aprs = REDIS.get(cache_key)
        mortgage_aprs = JSON.parse(mortgage_aprs)
      else
        loan_tek = HomepageRateServices::LoanTek.call
        quicken_loans = HomepageRateServices::Quickenloans.call
        wellsfargo = HomepageRateServices::Wellsfargo.call

        mortgage_aprs = {
          "loan_tek" => loan_tek,
          "quicken_loans" => quicken_loans,
          "wellsfargo" => wellsfargo,
          "updated_at" => Time.zone.now
        }
        REDIS.set(cache_key, mortgage_aprs.to_json)
        REDIS.expire(cache_key, 24.hour.to_i)
      end
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
