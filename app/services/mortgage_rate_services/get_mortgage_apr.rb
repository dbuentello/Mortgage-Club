module MortgageRateServices
  class GetMortgageApr

    def self.call(refresh_cache = false)
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
          wells_fargo: wells_fargo
        }

        REDIS.set(cache_key, mortgage_aprs.to_json)
        REDIS.expire(cache_key, 24.hour.to_i)
      end
      mortgage_aprs
    end
  end
end