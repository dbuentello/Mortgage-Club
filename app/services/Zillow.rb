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

  base_uri "http://www.zillow.com/webservice"
  @key = "X1-ZWz1aylbpp3aiz_98wrk"

  def self.search_property(address, citystatezip)
    params = {
      'address' => address,
      'citystatezip' => citystatezip,
      'zws-id' => @key
    }
    parse(get('/GetDeepSearchResults.htm', :query => params))
  end

  def self.parse(response)
    if (response['searchresults']['response'])
      property = response['searchresults']['response']['results']['result'][0]
      property.merge!({
        :useCode => USE_CODE[property['useCode']]
      })
    end

    property
  end
end
