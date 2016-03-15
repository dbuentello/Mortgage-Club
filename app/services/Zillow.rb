class Zillow
  include HTTParty

  USE_CODE = {
    'Unknown'         => nil,
    'SingleFamily'    => :sfh,
    'Duplex'          => :duplex,
    'Triplex'         => :triplex,
    'Quadruplex'      => :quadruplex,
    'Condominium'     => :sfh
  }

  @key = "X1-ZWz1aylbpp3aiz_98wrk"

  def self.search_property(address, citystatezip)
    params = {
      'address' => address,
      'citystatezip' => citystatezip,
      'zws-id' => @key
    }
    parse_property(get('http://www.zillow.com/webservice/GetDeepSearchResults.htm', query: params))
  end

  def self.parse_property(response)
    if (response['searchresults']['response'])
      property = response['searchresults']['response']['results']['result'][0] || response['searchresults']['response']['results']['result']
      property.merge!(
        useCode: USE_CODE[property['useCode']]
      )

      params = {
        'zip' => property['address']['zipcode'],
        'price' => property['zestimate']['amount']['__content__'],
        'zws-id' => @key
      }

      parse_payments(get('http://www.zillow.com/webservice/mortgage/CalculateMonthlyPaymentsAdvanced.htm', query: params), property)
    end
  end

  def self.parse_payments(response, property)
    property.merge(
      monthlyTax: response['paymentsdetails']['response']['monthlypropertytaxes'],
      monthlyInsurance: response['paymentsdetails']['response']['monthlyhazardinsurance']
    )
  end
end
