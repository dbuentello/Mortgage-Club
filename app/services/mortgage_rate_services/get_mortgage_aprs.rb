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
        if should_edit_rate?(rate, quicken_loans[type], wells_fargo[type])
          zillow[type] = (quicken_loans[type] > wells_fargo[type]) ? (wells_fargo[type] - 0.125) : (quicken_loans[type] - 0.125)
        end
      end
    end

    def self.should_edit_rate?(zillow_rate, quicken_loans_rate, wells_fargo_rate)
      zillow_rate == 0 || zillow_rate > quicken_loans_rate || zillow_rate > wells_fargo_rate
    end
  end
end
