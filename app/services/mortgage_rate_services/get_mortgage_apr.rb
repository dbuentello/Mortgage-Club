module MortgageRateServices
  class GetMortgageApr

    def self.call
      cache_key = "mortgage-apr"

      if mortgage_apr = REDIS.get(cache_key)
        mortgage_apr = JSON.parse(mortgage_apr)
      else
        zillow = MortgageRateServices::Zillow.call
        quicken_loans = MortgageRateServices::Quickenloans.call
        wells_fargo = MortgageRateServices::Wellsfargo.call

        mortgage_apr = {
          zillow: zillow,
          quicken_loans: quicken_loans,
          wells_fargo: wells_fargo
        }

        REDIS.set(cache_key, mortgage_apr.to_json)
        REDIS.expire(cache_key, 24.hour.to_i)
      end
      mortgage_apr
    end
  end
end