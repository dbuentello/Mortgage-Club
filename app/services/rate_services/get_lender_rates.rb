module RateServices
  class GetLenderRates
    def self.call(zipcode)
      ZillowService::GetMortgageRate.call(zipcode)
    end
  end
end