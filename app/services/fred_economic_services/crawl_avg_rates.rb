module FredEconomicServices
  class CrawlAvgRates
    YEAR_FIXED_30 = "MORTGAGE30US"
    YEAR_FIXED_15 = "MORTGAGE15US"
    YEAR_ARM_5 = "MORTGAGE5US"
    @@rates = Hash.new{|hsh,key| hsh[key] = {} }

    def self.call
      crawl_data(YEAR_FIXED_30, nil, nil)
      crawl_data(YEAR_FIXED_15, nil, nil)
      crawl_data(YEAR_ARM_5, nil, nil)
      @@rates.each do |key, value|
        @rate = FredEconomic.new(event_date: key, year_fixed_30: value[YEAR_FIXED_30], year_fixed_15: value[YEAR_FIXED_15], year_arm_5: value[YEAR_ARM_5])
        @rate.save
      end
    end

    def self.update
      crawl_data(YEAR_FIXED_30, nil, nil)
      crawl_data(YEAR_FIXED_15, nil, nil)
      crawl_data(YEAR_ARM_5, nil, nil)
      @@rates.each do |key, value|
        @rate = FredEconomic.new(event_date: key, year_fixed_30: value[YEAR_FIXED_30], year_fixed_15: value[YEAR_FIXED_15], year_arm_5: value[YEAR_ARM_5])
        @rate.save
      end
    end
    
    def self.crawl_data(type, cosd, coed)
      connection = Faraday.new(url: create_url(type, cosd, coed))
      response = connection.get
      data = JSON.parse(response.body)
      if data.present?
        obs = data["seriess"][0]["obs"]
        obs.each do | r |
          @@rates[Date.strptime(r[0].to_s, '%Q')].store type, r[1]
        end
      end

    end

    def self.create_url(type, cosd, coed)
      return "https://research.stlouisfed.org/fred2/graph/graph-data.php?mode=fred&id=#{type}&fq=Weekly%2C+Ending+Thursday&fam=avg&transformation=lin&nd=&ost=-99999&oet=99999&lsv=&lev=&fml=a&fgst=lin&fgsnd=2007-12-01&mma=0&scale=left&line_color=%234572a7&vintage_date=&revision_date=&chart_type=line&drp=0&cosd=#{cosd}&coed=#{coed}&log_scales="
    end

  end
end
