module HomepageRateServices
  class GetMortgageAprs
    def self.call(refresh_cache = false)
      # return default_aprs unless Rails.env.production?
      refresh_cache = true
      cache_key = "mortgage-apr"

      if !refresh_cache && mortgage_aprs = REDIS.get(cache_key)
        mortgage_aprs = JSON.parse(mortgage_aprs)
      else
        loan_tek = HomepageRateServices::LoanTek.call
        quicken_loans = HomepageRateServices::Quickenloans.call
        wellsfargo = HomepageRateServices::Wellsfargo.call

        edit_rates(loan_tek, quicken_loans, wellsfargo)

        mortgage_aprs = {
          "loan_tek" => loan_tek,
          "quicken_loans" => quicken_loans,
          "wellsfargo" => wellsfargo,
          "updated_at" => Time.zone.now
        }
        REDIS.set(cache_key, mortgage_aprs.to_json)
        REDIS.expire(cache_key, 24.hour.to_i)
      end
      mortgage_aprs
    end

    def self.default_aprs
      {
        "loan_tek" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "quicken_loans" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "wellsfargo" => {
          "apr_30_year" => 0,
          "apr_15_year" => 0,
          "apr_5_libor" => 0
        },
        "updated_at" => Time.zone.now
      }
    end

    def self.edit_rates(loan_tek, quicken_loans, wellsfargo)
      loan_tek.each do |type, rate|
        quicken_loans_rate = quicken_loans[type]
        wellsfargo_rate = wellsfargo[type]
        offset = (type == "apr_30_year".freeze) ? 0.538 : 0.125

        if should_edit_rate?(rate, quicken_loans_rate, wellsfargo_rate, type)
          loan_tek[type] = [quicken_loans_rate, wellsfargo_rate].min - offset
        end
      end
    end

    def self.should_edit_rate?(loan_tek_rate, quicken_loans_rate, wellsfargo_rate, type)
      if type == "apr_30_year".freeze
        return (loan_tek_rate == 0 || loan_tek_rate > ([quicken_loans_rate, wellsfargo_rate].min - 0.375))
      else
        return (loan_tek_rate == 0 || loan_tek_rate > [quicken_loans_rate, wellsfargo_rate].min)
      end
    end
  end
end
