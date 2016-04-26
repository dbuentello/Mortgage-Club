require "quotes_formulas"

module LoanTekServices
  class ReadQuotes
    extend QuotesFormulas

    def self.call(quotes, loan_purpose)
      lender_info = get_lender_info(quotes)
      programs = []
      quotes = get_valid_quotes(quotes)

      quotes.each do |quote|
        discount_pts = quote["DiscountPts"] / 100
        lender_name = quote["LenderName"]
        rate = get_interest_rate(quote)
        apr = get_apr(quote)
        admin_fee = get_admin_fee(quote)
        product = get_product_name(quote)

        next if existing_program?(programs: programs, apr: apr, rate: rate, lender_name: lender_name, discount_pts: discount_pts, product: product)

        program = {
          lender_name: lender_name,
          product: product,
          apr: apr,
          loan_amount: quote["FeeSet"]["LoanAmount"],
          interest_rate: rate,
          total_fee: get_total_fee(quote, admin_fee),
          fees: get_fees(quote),
          period: get_period(quote),
          down_payment: get_down_payment(quote, loan_purpose),
          monthly_payment: get_monthly_payment(quote),
          lender_credits: get_lender_credits(quote, admin_fee),
          total_closing_cost: get_total_closing_cost(quote, admin_fee),
          nmls: lender_info[quote["LenderName"]] ? lender_info[quote["LenderName"]][:nmls] : nil,
          logo_url: lender_info[quote["LenderName"]] ? lender_info[quote["LenderName"]][:logo_url] : nil,
          loan_type: quote["ProductFamily"],
          discount_pts: discount_pts_equals_to_0_125?(quote) || check_to_hide_admin_fee(quote, admin_fee) ? 0 : discount_pts
        }
        programs << program
      end
      programs = build_characteristics(programs)
      programs.sort_by { |program| program[:apr] }
    end

    def self.existing_program?(programs, apr, rate, lender_name, discount_pts, product)
      programs.each do |program|
        return true if program[:lender_name] == lender_name && program[:apr] == apr && program[:interest_rate] == rate && program[:discount_pts] == discount_pts && program[:product] == product
      end

      false
    end

    def self.get_lender_info(quotes)
      lender_names = quotes.map { |q| q["LenderName"] }.uniq
      lender_info = {}
      Lender.where(name: lender_names).each do |lender|
        lender_info[lender.name] = {nmls: lender.nmls, logo_url: lender.logo_url}
      end
      lender_info
    end

    def self.get_down_payment(quote, loan_purpose)
      # loan purpose
      # 1: purchase
      # 2: refinance

      return nil if loan_purpose == 2 || quote["LoanToValue"].nil?

      loan_amount = quote["FeeSet"]["LoanAmount"].to_f
      property_value = loan_amount / (quote["LoanToValue"].to_f / 100.0)

      property_value - loan_amount
    end

    def self.get_monthly_payment(quote)
      period = get_period(quote)
      rate_per_period = get_interest_rate(quote) / 12
      numerator = rate_per_period * ((1 + rate_per_period)**period)
      denominator = ((1 + rate_per_period)**period) - 1
      payment = quote["FeeSet"]["LoanAmount"].to_f * (numerator / denominator)
      payment.round
    end

    def self.get_lender_credits(quote, admin_fee)
      return 0.0 if quote["DiscountPts"].nil?
      return 0.0 if quote["DiscountPts"].to_f >= 0 && quote["DiscountPts"].to_f <= 0.125

      total_fee = quote["DiscountPts"] / 100 * quote["FeeSet"]["LoanAmount"] + admin_fee

      return 0.0 if total_fee >= 0 && total_fee <= 1000

      total_fee
    end

    def self.get_total_closing_cost(quote, admin_fee)
      total_fee = get_total_fee(quote, admin_fee)
      lender_credit = get_lender_credits(quote, admin_fee)

      total_fee + lender_credit
    end

    def self.get_admin_fee(quote)
      return 0.0 unless quote["FeeSet"]
      return 0.0 unless quote["FeeSet"]["Fees"]

      admin_fee = quote["FeeSet"]["Fees"].find { |x| x["Description"] == "Administration fee" }

      return 0.0 unless admin_fee

      admin_fee["FeeAmount"].to_f
    end

    def self.get_fees(quote)
      return [] unless quote["FeeSet"]
      return [] unless quote["FeeSet"]["Fees"]

      quote["FeeSet"]["Fees"].reject { |x| x["Description"] == "Administration fee" }
    end

    def self.get_total_fee(quote, admin_fee)
      quote["FeeSet"]["TotalFees"].to_f - admin_fee
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
        "7/1 ARM", "5/1 ARM", "FHA"
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
        program[:apr] - characteristics[program[:product]][:apr] > 0.00625
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

    def self.existing_program?(args)
      args[:programs].each do |program|
        return true if program[:lender_name] == args[:lender_name] &&
                       program[:apr] == args[:apr] &&
                       program[:interest_rate] == args[:rate] &&
                       program[:discount_pts] == args[:discount_pts] &&
                       program[:product] == args[:product]
      end

      false
    end
  end
end
