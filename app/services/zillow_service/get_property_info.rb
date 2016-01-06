module ZillowService
  class GetPropertyInfo
    include HTTParty

    USE_CODE = {
      'Unknown'         => nil,
      'SingleFamily'    => :sfh,
      'Duplex'          => :duplex,
      'Triplex'         => :triplex,
      'Quadruplex'      => :quadruplex,
      'Condominium'     => :sfh
    }

    # ZILLOW_KEY = "X1-ZWz1aylbpp3aiz_98wrk"
    ZILLOW_KEY = "X1-ZWz1a4mphgfggb_7zykg"

    def self.call(address, citystatezip)
      property_data = get_property_data(address, citystatezip)
      monthly_payments = get_monthly_payments_advanced(property_data)
      zillow_image_url = get_zillow_image_url(property_data)
      merge_data(monthly_payments, property_data, zillow_image_url)
    end

    def self.get_property_data(address, citystatezip)
      params = {
        'address' => address,
        'citystatezip' => citystatezip,
        'zws-id' => ZILLOW_KEY
      }
      get('http://www.zillow.com/webservice/GetDeepSearchResults.htm', query: params)
    end

    def self.get_monthly_payments_advanced(property_data)
      return unless has_property?(property_data)

      property = property_data['searchresults']['response']['results']['result'][0] || property_data['searchresults']['response']['results']['result']
      property.merge!({
        useCode: USE_CODE[property['useCode']]
      })

      params = {
        'zip' => property['address']['zipcode'],
        'price' => property['zestimate']['amount']['__content__'],
        'zws-id' => ZILLOW_KEY
      }

      get('http://www.zillow.com/webservice/mortgage/CalculateMonthlyPaymentsAdvanced.htm', query: params)
    end

    def self.merge_data(monthly_payments, property_data, zillow_image_url)
      return unless has_monthly_payment?(monthly_payments)

      property = property_data['searchresults']['response']['results']['result'][0] || property_data['searchresults']['response']['results']['result']
      property.merge({
        monthlyTax: monthly_payments['paymentsdetails']['response']['monthlypropertytaxes'],
        monthlyInsurance: monthly_payments['paymentsdetails']['response']['monthlyhazardinsurance'],
        zillowImageUrl: zillow_image_url
      })
    end

    def self.get_zillow_image_url(property_data)
      return unless zpid = zpid(property_data)

      params = {
        'zpid' => zpid,
        'zws-id' => ZILLOW_KEY
      }
      data = get('http://www.zillow.com/webservice/GetUpdatedPropertyDetails.htm', query: params)
      if has_images?(data)
        url = data["updatedPropertyDetails"]["response"]["images"]["image"]["url"].first
      else
        url = ""
      end
      url
    end

    def self.zpid(property_data)
      return unless has_zpid?(property_data)

      property = property_data['searchresults']['response']['results']['result'][0] || property_data['searchresults']['response']['results']['result']
      property['zpid']
    end

    def self.has_images?(data)
      data["updatedPropertyDetails"]["response"] && data["updatedPropertyDetails"]["response"]["images"]
    end

    def self.has_zpid?(data)
      data['searchresults'] && data['searchresults']['response']
    end

    def self.has_monthly_payment?(data)
      data.present? && data['paymentsdetails']['response']
    end

    def self.has_property?(data)
      data['searchresults'] && data['searchresults']['response']
    end
  end
end
