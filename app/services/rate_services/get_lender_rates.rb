module RateServices
  class GetLenderRates
    def self.call(loan_id, zipcode)
      ZillowService::GetMortgageRate.call(loan_id, zipcode)
    end
  end
end