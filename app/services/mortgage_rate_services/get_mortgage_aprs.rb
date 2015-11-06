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

        mortgage_aprs = {
          zillow: zillow,
          quicken_loans: quicken_loans,
          wells_fargo: wells_fargo,
          updated_at: Time.zone.now
        }

        REDIS.set(cache_key, mortgage_aprs.to_json)
        REDIS.expire(cache_key, 24.hour.to_i)
      end
      mortgage_aprs
    end

    def self.default_aprs
      {
        zillow: {
          apr_30_year: nil,
          apr_15_year: nil,
          apr_5_libor: nil
        },
        quicken_loans: {
          apr_30_year: nil,
          apr_15_year: nil,
          apr_5_libor: nil
        },
        wells_fargo: {
          apr_30_year: nil,
          apr_15_year: nil,
          apr_5_libor: nil
        },
        updated_at: Time.zone.now
      }
    end
  end
end
