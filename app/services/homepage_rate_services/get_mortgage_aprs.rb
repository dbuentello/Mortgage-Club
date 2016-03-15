module HomepageRateServices
  class GetMortgageAprs
    MAPPING_LENDER = {
      "Mortgage Club" => "loan_tek",
      "Wells Fargo" => "wellsfargo",
      "Quicken Loans" => "quicken_loans"
    }

    def self.call(refresh_cache = false)
      return HomepageRateServices::CrawlMortgageAprs.default_aprs if Rails.env.test?

      cache_key = "mortgage-apr"

      if !refresh_cache && mortgage_aprs = REDIS.get(cache_key)
        aprs = JSON.parse(mortgage_aprs)
      else
        aprs = get_aprs

        REDIS.set(cache_key, aprs.to_json)
        REDIS.expire(cache_key, 168.hours)
      end

      aprs
    end

    def self.get_aprs
      aprs = HomepageRateServices::CrawlMortgageAprs.default_aprs

      MAPPING_LENDER.each do |key, value|
        rates = HomepageRate.today_rates.where(lender_name: key)

        rates.each do |rate|
          aprs[value]["apr_30_year"] = parse_rate_value(rate) if rate.program == "30 Year Fixed"
          aprs[value]["apr_15_year"] = parse_rate_value(rate) if rate.program == "15 Year Fixed"
          aprs[value]["apr_5_libor"] = parse_rate_value(rate) if rate.program == "5/1 Libor ARM"
        end
      end

      aprs["updated_at"] = HomepageRate.today_rates.pluck(:display_time).max

      aprs
    end

    def self.parse_rate_value(rate)
      return "-" unless rate.rate_value

      sprintf("%0.03f", rate.rate_value) + "%"
    end
  end
end
