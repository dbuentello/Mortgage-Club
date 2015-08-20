module ZillowService
  class GetZpid
    include HTTParty
    include ZillowService::ZillowApi

    def self.call(address, citystatezip)
      params = {
        'address' => address,
        'citystatezip' => citystatezip,
        'zws-id' => ZILLOW_KEY
      }
      response = get('http://www.zillow.com/webservice/GetDeepSearchResults.htm', query: params)

      if (response['searchresults'] && response['searchresults']['response'])
        return response['searchresults']['response']['results']['result'][0]['zpid']
      end
    end
  end
end
