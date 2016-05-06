module ZillowService
  class GetHomeValueAndPropertyType
    include HTTParty

    USE_CODE = {
      "Unknown"         => nil,
      "SingleFamily"    => "sfh",
      "Duplex"          => "duplex",
      "Triplex"         => "triplex",
      "Quadruplex"      => "fourplex",
      "Condominium"     => "sfh",
      "Townhouse"       => "sfh"
    }

    def self.call(address, zipcode)
      params = {
        "address" => address,
        "citystatezip" => zipcode,
        "zws-id" => "X1-ZWz1aylbpp3aiz_98wrk"
      }

      response = get("http://www.zillow.com/webservice/GetDeepSearchResults.htm", query: params)

      if success?(response)
        {
          current_home_value: get_current_home_value(response),
          property_type: get_property_type(response)
        }
      end
    end

    def self.get_current_home_value(response)
      return unless response["searchresults"] && response["searchresults"]["response"]
      data = response["searchresults"]["response"]["results"]["result"][0] || response["searchresults"]["response"]["results"]["result"]
      data["zestimate"]["amount"]["__content__"].to_i if data["zestimate"]
    end

    def self.get_property_type(response)
      return unless response["searchresults"] && response["searchresults"]["response"]
      data = response["searchresults"]["response"]["results"]["result"][0] || response["searchresults"]["response"]["results"]["result"]
      USE_CODE.fetch(data["useCode"], nil)
    end

    def self.success?(response)
      response["searchresults"]["message"]["code"] == "0"
    end
  end
end
