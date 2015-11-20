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
        chase = MortgageRateServices::Chase.call

        edit_rates(zillow, quicken_loans, chase)

        mortgage_aprs = {
          "zillow" => zillow,
          "quicken_loans" => quicken_loans,
          "chase" => chase,
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
        "chase" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "updated_at" => Time.zone.now
      }
    end

    def self.edit_rates(zillow, quicken_loans, chase)
      zillow.each do |type, rate|
        quicken_loans_rate = quicken_loans[type]
        chase_rate = chase[type]
        offset = (type == "apr_30_year".freeze) ? 0.538 : 0.125

        if should_edit_rate?(rate, quicken_loans_rate, chase_rate, type)
          zillow[type] = [quicken_loans_rate, chase_rate].min - offset
        end
      end
    end

    def self.should_edit_rate?(zillow_rate, quicken_loans_rate, chase_rate, type)
      if type == "apr_30_year".freeze
        return (zillow_rate == 0 || zillow_rate > ([quicken_loans_rate, chase_rate].min - 0.375))
      else
        return (zillow_rate == 0 || zillow_rate > [quicken_loans_rate, chase_rate].min)
      end
    end
  end
end
