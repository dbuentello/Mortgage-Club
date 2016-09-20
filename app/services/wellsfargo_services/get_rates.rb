module WellsfargoServices
  class GetRates
    attr_accessor :args

    def initialize(args)
      @args = args
    end

    def call
      a = Mechanize.new
      a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      body = {
        "loanPurpose" => args[:loan_purpose].downcase,
        "homeValue" => args[:property_value],
        "downPayment" => args[:down_payment],
        "mortgageBalance" => "",
        "loanAmount" => args[:loan_amount],
        "state" => "CA",
        "county" => args[:county]
      }

      result = a.post("https://www.wellsfargo.com/pi_action/rpcCalc", body)

      if result.code == "200"
        parse(result)
      else
        []
      end
    end

    def parse(result)
      rates = []
      fixed_30 = result.search(".subtle tr")[1]
      fixed_15 = result.search(".subtle tr")[4]
      arm_5 = result.search(".subtle tr")[5]

      if fixed_30 && fixed_15 && arm_5
        rates << {
          product_name: "30yearFixed",
          product_type: "FIXED",
          product_term: "F30",
          interest_rate: fixed_30.search("td")[0].text.to_f,
          apr: fixed_30.search("td")[1].text.to_f
        }

        rates << {
          product_name: "15yearFixed",
          product_type: "FIXED",
          product_term: "F15",
          interest_rate: fixed_15.search("td")[0].text.to_f,
          apr: fixed_15.search("td")[1].text.to_f
        }

        rates << {
          product_name: "5yearARM",
          product_type: "ARM",
          product_term: "A5_1",
          interest_rate: arm_5.search("td")[0].text.to_f,
          apr: arm_5.search("td")[1].text.to_f
        }
      end

      rates
    end
  end
end
