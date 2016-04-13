module FredEconomicServices
  class CrawlAvgRates
    YEAR_FIXED_30 = "MORTGAGE30US"
    YEAR_FIXED_15 = "MORTGAGE15US"
    YEAR_ARM_5 = "MORTGAGE5US"

    # call one time for crawling data from https://research.stlouisfed.org/fred2/series/MORTGAGE30US
    def self.call
      @rates = Hash.new { |hsh, key| hsh[key] = {} }
      crawl_data(YEAR_FIXED_30, nil, nil, @rates)
      crawl_data(YEAR_FIXED_15, nil, nil, @rates)
      crawl_data(YEAR_ARM_5, nil, nil, @rates)
      @rates.each do |key, value|
        @rate = FredEconomic.new(event_date: key, year_fixed_30: value[YEAR_FIXED_30], year_fixed_15: value[YEAR_FIXED_15], year_arm_5: value[YEAR_ARM_5])
        @rate.save
      end
    end

    # weekly update on Friday.
    def self.update
      @rates = Hash.new { |hsh, key| hsh[key] = {} }
      coed = Time.zone.today
      cosd = coed - 7
      crawl_data(YEAR_FIXED_30, cosd.to_s, coed.to_s, @rates)
      crawl_data(YEAR_FIXED_15, cosd.to_s, coed.to_s, @rates)
      crawl_data(YEAR_ARM_5, cosd.to_s, coed.to_s, @rates)
      @rates.each do |key, value|
        FredEconomic.find_or_create_by(event_date: key) do |rate|
          rate.year_fixed_30 = value[YEAR_FIXED_30]
          rate.year_fixed_15 = value[YEAR_FIXED_15]
          rate.year_arm_5 = value[YEAR_ARM_5]
        end
      end
    end

    def self.crawl_data(type, cosd, coed, rates)
      connection = Faraday.new(url: create_url(type, cosd, coed))
      response = connection.get
      data = JSON.parse(response.body)
      if data.present?
        obs = data["seriess"][0]["obs"]
        obs.each do |r|
          rates[Date.strptime(r[0].to_s, '%Q')].store type, r[1]
        end
      end
    end

    def self.create_url(type, cosd, coed)
      "https://research.stlouisfed.org/fred2/graph/graph-data.php?mode=fred&id=#{type}&fq=Weekly%2C+Ending+Thursday&fam=avg&transformation=lin&nd=&ost=-99999&oet=99999&lsv=&lev=&fml=a&fgst=lin&fgsnd=2007-12-01&mma=0&scale=left&line_color=%234572a7&vintage_date=&revision_date=&chart_type=line&drp=0&cosd=#{cosd}&coed=#{coed}&log_scales="
    end
  end
end
