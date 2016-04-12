module FredEconomicServices

  class CrawlAvgRates
    YEAR_FIXED_30 = "MORTGAGE30US"
    YEAR_FIXED_15 = "MORTGAGE15US"
    YEAR_ARM_5 = "MORTGAGE5US"
    def self.call
      h = Hash.new{|hsh,key| hsh[key] = {} }
      rates_30 = crawl_data(YEAR_FIXED_30, nil, nil)
      rates_30.each do | r |
        h[Time.strptime(r[0].to_s, '%Q')].store YEAR_FIXED_30, r[1]
      end
      rates_15 = crawl_data(YEAR_FIXED_15, nil, nil)
      rates_15.each do | r |
        h[Time.strptime(r[0].to_s, '%Q')].store YEAR_FIXED_15, r[1]
      end
      rates_5 = crawl_data(YEAR_ARM_5, nil, nil)
      rates_5.each do | r |
        h[Time.strptime(r[0].to_s, '%Q')].store YEAR_ARM_5, r[1]
      end
      p h
    end
    def self.crawl_data(type, cosd, coed)
      connection = Faraday.new(url: create_url(type, cosd, coed))
      response = connection.get
      return JSON.parse(response.body)["seriess"][0]["obs"]
    end
    def self.create_url(type, cosd, coed)
      return "https://research.stlouisfed.org/fred2/graph/graph-data.php?mode=fred&id=#{type}&fq=Weekly%2C+Ending+Thursday&fam=avg&transformation=lin&nd=&ost=-99999&oet=99999&lsv=&lev=&fml=a&fgst=lin&fgsnd=2007-12-01&mma=0&scale=left&line_color=%234572a7&vintage_date=&revision_date=&chart_type=line&drp=0&cosd=#{cosd}&coed=#{coed}&log_scales="
    end

  end
end
