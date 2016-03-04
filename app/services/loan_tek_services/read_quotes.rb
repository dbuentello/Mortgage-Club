module LoanTekServices
  class ReadQuotes
    PRODUCT = {
      "40yearFixed" => "40 year fixed",
      "30yearFixed" => "30 year fixed",
      "25yearFixed" => "25 year fixed",
      "20yearFixed" => "20 year fixed",
      "15yearFixed" => "15 year fixed",
      "10yearFixed" => "10 year fixed",
      "7yearARM" => "7 year ARM",
      "5yearARM" => "5 year ARM",
      "3yearARM" => "3 year ARM",
      "1yearARM" => "1 year ARM",
    }

    def self.call(quotes)
      lender_info = get_lender_info(quotes)

      programs = []
      quotes.each do |quote|
        if quote["DiscountPts"] > -1
          apr = quote["APR"] / 100
          rate = get_interest_rate(quote)
          lender_name = quote["LenderName"]
          discount_pts = quote["DiscountPts"] / 100

          program = select_program_exist(programs, apr, rate, lender_name, discount_pts)

          if program.empty?
            program = {
              lender_name: lender_name,
              product: get_product_name(quote),
              apr: apr,
              loan_amount: quote["FeeSet"]["LoanAmount"],
              interest_rate: rate,
              total_fee: quote["FeeSet"]["TotalFees"],
              fees: quote["FeeSet"]["Fees"] || [],
              period: get_period(quote),
              down_payment: get_down_payment(quote),
              monthly_payment: get_monthly_payment(quote),
              lender_credit: get_lender_credit(quote),
              total_closing_cost: get_total_closing_cost(quote),
              nmls: lender_info[quote["LenderName"]] ? lender_info[quote["LenderName"]][:nmls] : nil,
              logo_url: lender_info[quote["LenderName"]] ? lender_info[quote["LenderName"]][:logo_url] : nil,
              loan_type: quote["ProductFamily"],
              discount_pts: discount_pts
            }
            programs << program
          end
        end
      end

      programs = build_characteristics(programs)
      programs.sort_by { |program| program[:apr] }
    end

    def self.select_program_exist(programs, apr, rate, lender_name, discount_pts)
      programs.select do |program|
        program[:lender_name] == lender_name && program[:apr] == apr && program[:interest_rate] == rate && program[:discount_pts] == discount_pts
      end
    end

    def self.get_lender_info(quotes)
      lender_names = quotes.map { |q| q["LenderName"] }
      lender_info = {}
      Lender.where(name: lender_names).each do |lender|
        lender_info[lender.name] = {nmls: lender.nmls, logo_url: lender.logo_url}
      end
      lender_info
    end

    def self.get_down_payment(quote)
      quote["FeeSet"]["LoanAmount"].to_f * 0.2
    end

    def self.get_monthly_payment(quote)
      period = get_period(quote)
      rate_per_period = get_interest_rate(quote) / 12
      numerator = rate_per_period * ((1 + rate_per_period) ** period)
      denominator = ((1 + rate_per_period) ** period) - 1
      payment = quote["FeeSet"]["LoanAmount"].to_f * (numerator / denominator)
      payment.round
    end

    def self.get_lender_credit(quote)
      quote["Fees"] < 0 ? quote["Fees"] : 0
    end

    def self.get_total_closing_cost(quote)
      total_fee = quote["FeeSet"]["TotalFees"].to_f
      lender_credit = get_lender_credit(quote)
      total_fee - lender_credit
    end

    def self.get_product_name(quote)
      PRODUCT.fetch(quote["ProductName"], quote["ProductName"])
    end

    def self.get_period(quote)
      return 360 if self.arm?(quote)

      quote["ProductTerm"].to_i * 12
    end

    def self.get_interest_rate(quote)
      quote["Rate"].to_f / 100
    end

    def self.arm?(quote)
      quote["ProductTerm"].include? "/1"
    end

    def self.build_characteristics(programs)
      characteristics = {}
      [
        "30 year fixed", "15 year fixed",
        "7 year ARM", "5 year ARM", "FHA"
      ].each do |type|
        filtered_programs = filter_programs_by_product_type(programs, type)
        characteristics[type] = {
          apr: get_lowest_value(filtered_programs, :apr),
          interest_rate: get_lowest_value(filtered_programs, :interest_rate),
          total_closing_cost: get_lowest_value(filtered_programs, :total_closing_cost)
        }
      end

      programs.each do |program|
        if program[:apr] == characteristics[program[:product]][:apr]
          program[:characteristic] = "Of all #{program[:product]} mortgages on MortgageClub that you've qualified for, this one has the lowest APR."
        elsif program[:interest_rate] == characteristics[program[:product]][:interest_rate]
          program[:characteristic] = "Of all #{program[:product]} mortgages on MortgageClub that you've qualified for, this one has the lowest rate."
        elsif program[:total_closing_cost] == characteristics[program[:product]][:total_closing_cost]
          program[:characteristic] = "Of all #{program[:product]} mortgages on MortgageClub that you've qualified for, this one has the lowest total closing cost."
        end
      end

      programs = programs.reject do |program|
        program[:apr] - characteristics[program[:product]][:apr] > 0.01
      end
    end

    def self.filter_programs_by_product_type(programs, product_type)
      programs.select { |p| p[:product] == product_type }
    end

    def self.get_lowest_value(programs, type)
      return if programs.nil? || programs.empty?

      min = programs.first[type]
      programs.each { |p| min = p[type] if min > p[type] }
      min
    end
  end
end
