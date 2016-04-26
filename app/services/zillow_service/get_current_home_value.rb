module ZillowService
  class GetCurrentHomeValue
    include HTTParty

    def self.call(address, zipcode)
      params = {
        "address" => address,
        "citystatezip" => zipcode,
        "zws-id" => "X1-ZWz1aylbpp3aiz_98wrk"
      }
      response = get("http://www.zillow.com/webservice/GetDeepSearchResults.htm", query: params)
      get_current_home_value(response)
    end

    def self.get_current_home_value(response)
      return unless response["searchresults"] && response["searchresults"]["response"]
      data = response["searchresults"]["response"]["results"]["result"][0] || response["searchresults"]["response"]["results"]["result"]
      data["zestimate"]["amount"]["__content__"].to_i if data["zestimate"]
    end
  end
end