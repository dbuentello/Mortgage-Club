module ZillowService
  class GetMonthlyPayment
    attr_accessor :info, :zipcode, :property_value

    def initialize(info)
      @info = info
      @zipcode = info["zip_code"].to_s
      @property_value = info["property_value"]
    end

    def call
      return unless property_value.present?
      return unless zipcode.present?

      key = "X1-ZWz1aylbpp3aiz_98wrk"
      @zipcode = zipcode[0..4] if zipcode.length > 5

      url = "http://www.zillow.com/webservice/GetMonthlyPayments.htm?output=json&zws-id=#{key}&price=#{property_value.to_i}&zip=#{zipcode}"
      connection = Faraday.new(url: url)
      response = connection.get

      return unless response.status == 200

      get_monthly_payment(JSON.parse(response.body))
    end

    def get_monthly_payment(response)
      return unless response["response"].present?

      property_tax = response["response"]["monthlyPropertyTaxes"]
      hazard_insurance = response["response"]["monthlyHazardInsurance"]

      {
        property_tax: property_tax.to_f,
        hazard_insurance: hazard_insurance.to_f
      }
    end
  end
end
