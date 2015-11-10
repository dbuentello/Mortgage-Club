module MortgageRateServices
  class GetMortgageAprs
    def self.call(refresh_cache = false)
      return default_aprs if Rails.env.test?

      cache_key = "mortgage-apr"

      if !refresh_cache && mortgage_aprs = REDIS.get(cache_key)
        mortgage_aprs = JSON.parse(mortgage_aprs)
      else
        zillow = MortgageRateServices::Zillow.call
        quicken_loans = MortgageRateServices::Quickenloans.call
        wells_fargo = MortgageRateServices::Wellsfargo.call

        edit_rates(zillow, quicken_loans, wells_fargo)

        mortgage_aprs = {
          "zillow" => zillow,
          "quicken_loans" => quicken_loans,
          "wells_fargo" => wells_fargo,
          "updated_at" => Time.zone.now
        }
        REDIS.set(cache_key, mortgage_aprs.to_json)
        REDIS.expire(cache_key, 24.hour.to_i)
      end
      mortgage_aprs
    end

    def self.default_aprs
      {
        "zillow" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "quicken_loans" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "wells_fargo" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "updated_at" => Time.zone.now
      }
    end

    def self.edit_rates(zillow, quicken_loans, wells_fargo)
      zillow.each do |type, rate|
        quicken_loans_rate = quicken_loans[type]
        wells_fargo_rate = wells_fargo[type]
        if should_edit_rate?(rate, quicken_loans_rate, wells_fargo_rate)
          zillow[type] = [quicken_loans_rate, wells_fargo_rate].min - 0.538
        end
      end
    end

    def self.should_edit_rate?(zillow_rate, quicken_loans_rate, wells_fargo_rate)
      zillow_rate == 0 || zillow_rate > ([quicken_loans_rate, wells_fargo_rate].min - 0.375)
    end
  end
end
