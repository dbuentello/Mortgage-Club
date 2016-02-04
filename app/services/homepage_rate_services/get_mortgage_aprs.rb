module HomepageRateServices
  class GetMortgageAprs
    MAPPING_LENDER = {
      "Mortgage Club" => "loan_tek",
      "Wells Fargo" => "wellsfargo",
      "Quicken Loans" => "quicken_loans"
    }

    def self.call
      aprs = HomepageRateServices::CrawlMortgageAprs.default_aprs

      MAPPING_LENDER.each do |key, value|
        rates = HomepageRate.today_rates.where(lender_name: key)

        rates.each do |rate|
          aprs[value]["apr_30_year"] = parse_rate_value(rate) if rate.program == "30 Year Fixed"
          aprs[value]["apr_15_year"] = parse_rate_value(rate) if rate.program == "15 Year Fixed"
          aprs[value]["apr_5_libor"] = parse_rate_value(rate) if rate.program == "5/1 Libor ARM"
          aprs["updated_at"] ||= rate.created_at
        end
      end

      aprs
    end

    def self.parse_rate_value(rate)
      return "-" unless rate.rate_value

      "#{rate.rate_value.round(3)}%"
    end
  end
end
