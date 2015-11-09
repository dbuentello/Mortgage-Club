module ZillowService
  class GetMortgageRates
    attr_accessor :loan, :loan_id, :zipcode

    def initialize(loan_id, zipcode)
      @loan = Loan.find_by_id(loan_id)
      @loan_id = loan_id
      @zipcode = zipcode
    end

    def call
      return unless zipcode.present? && loan.present?

      @zipcode = zipcode[0..4] if zipcode.length > 5
      cache_key = "zillow-mortgage-rates-#{loan_id}-#{@zipcode}"


      if rates = REDIS.get(cache_key)
        rates = JSON.parse(rates)
      else
        rates = call_crawler_to_get_rates
        REDIS.set(cache_key, rates.to_json)
        REDIS.expire(cache_key, 8.hour.to_i)
      end

      rates
    end

    def call_crawler_to_get_rates
      purchase_price = get_purchase_price(loan)
      down_payment = get_down_payment(purchase_price)
      annual_income = get_annual_income(loan)

      ZillowService::CrawlZillowRates.new({
        zipcode: zipcode,
        purchase_price: purchase_price,
        down_payment: down_payment,
        annual_income: annual_income,
        number_of_results: 30
      }).call
    end

    private

    def get_purchase_price(loan)
      500000
      # loan.primary_property.purchase_price.round
    end

    def get_down_payment(purchase_price)
      100000
      # (purchase_price * 0.2).round
    end

    def get_annual_income(loan)
      200000
      # employment = loan.borrower.current_employment

      # if employment.present? && employment.current_salary.present?
      #   annual_income = (employment.current_salary * 12).round
      # else
      #   annual_income = 200000
      # end
      # annual_income
    end
  end
end
