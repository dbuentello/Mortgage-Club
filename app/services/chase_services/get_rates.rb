# rubocop:disable LineLength
module ChaseServices
  class GetRates
    attr_accessor :args

    def initialize(args)
      @args = args
    end

    def call
      a = Mechanize.new
      a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      body = {
        "__EVENTTARGET" => "",
        "__EVENTARGUMENT" => "",
        "__LASTFOCUS" => "",
        "__VIEWSTATEENCRYPTED" => "",
        "__VIEWSTATEGENERATOR" => "C03AF90E",
        "__EVENTVALIDATION" => "q3xYaZI1th2roYVYzZP+yNm8tDm2DQ0FlbVt7jMmY6oIrHvMgecblYybYiyzU89o2xjGDDZvzwCWWDcodPc42XKgOgKj0oRlgp0dHuBNWrNReErSZslENu0I7Kj8s2o2lciX+0OPjad5Kn52uxrmVv+RLwJXx/txh9O95rYZ3RbkiSj+JSqYcAtuYKMp7GKPnbGbyqpVSDr1WHH8TZ3HCTg4ZjiOn7tu83pczho7ytB8ZLPMACkXzhY5/0KeVrCIUazJarbks2lyLH1vOsZfuAcE8KPrEp9MxhLNKECA1V3m46haYPTO1eOVkcipPVcQsYYrNKSY378M0yGZ0azqQk7ftAivbB1Tah8Wt2SzPR4YzdUI352mCfZNb1LZ0CjruuSRJ47VzylLzvwGCrf3N+IWpU6Oiuzmrr8+5sNzWBUCRI/hwSaCQ4HNfhANfzb0sdM6WGzBVq7xEtKkaCBHisX5OBVPZsVBdS5Lrn7rStGnM/xKbmmiJ4kjdeY27evLS72ztcMIDwdIlBh0RUlTuT3lGdp/yLuWXYhENoqUoWIEv9Wm66Wg7EFgfqwHdiQ8WurIIxCfa6I1s3PGS4jYSHVR7242yHVED0mrolaHViNRpQuq+KTWqyfF0EZQmrj+mUNCvshcmZ8GwyjHzDAvDlm+NkWybfwG1E4Qo9Ol2Zi9YposOhXew4CCrX6fJjaoeZptuQqcZtNLxHVhY8ARpmBwNFA+nxkoDNIx3ba/uJgLvIM415UfVeSr86RiaNeuWRtjuGJQrDURM/5DHPjUl2v36Bps/14VuoJrDI1KkE5Zy1txRSLFfnkGnA+RYgxnhkObhugwUvXl1WPeTci7HTClVxVT2O8S+G4q5pBZNcGV2hXlQ4RRznHwc2/GCbaCOYMXwJpSzRef5iPN8kr0GzoLh06as6Q9NqQERKiLs5oZJGE+H0FKUkXQGby8TE32OqEvWlRc8vs2CLFQFvCn3tw3O36P3NhdDVtq44R6IO8aIrVKolbwX8IVfqM8HstqP+LtY8SNTp9G+bafykFK5MspWhK6VVvlGi0jLRq4pMMYTA2mUirFLYuUzC863c+38Rx1i5vV5z5lTX2PYxIei8kuC8GtWsd4fT3AKA/lAartPnNrC0d3uq5izopr/p31hLuzAeX6B0Ako4RhcPpS6cQ4ag6/ldGASj4jBkE1j4A+Tq7e6tVBP/Rju4EfmSMx2nWDnTYdyn85INkTCNd62zdgbaic4Ss/9NqGZyph18meVet+yjUwhg5C2wDorifz34IoDpae6f+BsEFKSJRNLT0bKgZ8Hx1IwNE0Zi9AeWdikqpyewVVn1ykxyAl0xvY2FZuKyWCFCaFhHzfZRNkT9r9SRpFZLhDk16HhSZfCPF7JFlrgfkSgCwXy0DemUy0Qkfdvle/2uoErXFVha4paXASEEgtd2piJcB0qRXCJGDGsSKqNkXBIkbe4haTCPbNoDtQguH1ZafiN7lRwHlXU//40UWGpdsHcg1h7TU42L1vWHXPJW7Ry/26V4ZLTluZIbE9gXQXivDUCdbJAbw3lnqRcNpf3G9CsQ1/odHLheQXRVtu+J74ThzihIjytj5MWc4nQIMPycZhx+7CMIjhCxtM2rZqyMPuEA+EVPZ6N9c0Cu+hOZhXV4QMK2X3UB0QX0bDRTojLXyjyJevq6Kcn8QtpXI5I7gI/AsgtJ8KGhjrZIZE4bPJ48Gdzo6oi6S6ErKDmg==",
        "__VIEWSTATE" => "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",
        "ctl00$CenterContentPlaceHolder$CRQControl$loanTypeList" => "0",
        "ctl00$CenterContentPlaceHolder$CRQControl$homePrice" => "500000",
        "ctl00$CenterContentPlaceHolder$CRQControl$propertyTypeList" => "0",
        "ctl00$CenterContentPlaceHolder$CRQControl$downPayment" => "100000",
        "ctl00$CenterContentPlaceHolder$CRQControl$propertyUsageList" => "0",
        "ctl00$CenterContentPlaceHolder$CRQControl$pointsList" => "0",
        "ctl00$CenterContentPlaceHolder$CRQControl$stateList" => "CA",
        "ctl00$CenterContentPlaceHolder$CRQControl$ficoScore" => "740",
        "ctl00$CenterContentPlaceHolder$RateandPayment.x" => "106",
        "ctl00$CenterContentPlaceHolder$RateandPayment.y" => "6"
      }

      a.post("https://apply.chase.com/mortgage/CRQ/CustomRateQuote.aspx", body)
      # if result.code == "200"
      #   parse(result)
      # else
      #   []
      # end
    end

    def parse(result)
      rates = []
      fixed_30 = result.search(".subtle tr")[1]
      fixed_15 = result.search(".subtle tr")[4]
      arm_5 = result.search(".subtle tr")[5]

      if fixed_30 && fixed_15 && arm_5
        rates << {
          lender_name: "Wells Fargo",
          product_name: "30yearFixed",
          product_type: "FIXED",
          product_term: "F30",
          interest_rate: fixed_30.search("td")[0].text.to_f,
          apr: fixed_30.search("td")[1].text.to_f
        }

        rates << {
          lender_name: "Wells Fargo",
          product_name: "15yearFixed",
          product_type: "FIXED",
          product_term: "F15",
          interest_rate: fixed_15.search("td")[0].text.to_f,
          apr: fixed_15.search("td")[1].text.to_f
        }

        rates << {
          lender_name: "Wells Fargo",
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
# rubocop:enable LineLength
