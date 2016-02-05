module HomepageRateServices
  class CreateTodayHomepageRates
    MAPPING_LENDER = {
      "Mortgage Club" => "loan_tek",
      "Wells Fargo" => "wellsfargo",
      "Quicken Loans" => "quicken_loans"
    }

    MAPPING_PROGRAM = {
      "30 Year Fixed" => "apr_30_year",
      "15 Year Fixed" => "apr_15_year",
      "5/1 Libor ARM" => "apr_5_libor"
    }

    def self.call
      rates = HomepageRateServices::CrawlMortgageAprs.call
      lender_names = ["Mortgage Club", "Wells Fargo", "Quicken Loans"]
      programs = ["30 Year Fixed", "15 Year Fixed", "5/1 Libor ARM"]
      lender_names.each do |lender|
        lender_rate = rates[MAPPING_LENDER[lender]]
        programs.each do |program|
          homepage_rate = HomepageRate.find_or_initialize_by(lender_name: lender, program: program)
          homepage_rate.rate_value = lender_rate[MAPPING_PROGRAM[program]]
          homepage_rate.display_time = homepage_rate.id.nil? ? Time.zone.now.beginning_of_day : Time.zone.now
          homepage_rate.save
        end
      end
    end
  end
end
