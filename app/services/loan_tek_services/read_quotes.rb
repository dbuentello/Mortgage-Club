require "quotes_formulas"

module LoanTekServices
  class ReadQuotes
    extend QuotesFormulas

    def self.call(quotes, loan_purpose, fees, property_value, is_cash_out = false, is_down_payment = false)
      lender_info = get_lender_info(quotes)
      programs = []
      quotes = get_valid_quotes(quotes)

      quotes.each do |quote|
        discount_pts = quote["DiscountPts"] / 100
        lender_name = quote["LenderName"]
        rate = get_interest_rate(quote)
        apr = get_apr(quote)
        product = get_product_name(quote)
        thirty_fees = get_thirty_fees(fees, lender_info[lender_name])
        prepaid_fees = get_prepaid_fees(quote["FeeSet"]["LoanAmount"], rate)
        lender_underwriting_fee = lender_info[lender_name] ? lender_info[lender_name][:lender_underwriting_fee].to_f : 0
        fha_upfront_premium_amount = get_fha_upfront_premium_amount(quote)
        lender_credits = get_lender_credits(quote)

        next if existing_program?(programs: programs, apr: apr, rate: rate, lender_name: lender_name, discount_pts: discount_pts, product: product)

        program = {
          property_value: property_value,
          lender_name: lender_name,
          product: product,
          apr: apr,
          loan_amount: quote["FeeSet"]["LoanAmount"],
          interest_rate: rate,
          period: get_period(quote),
          down_payment: get_down_payment(quote, loan_purpose),
          monthly_payment: get_monthly_payment(quote),
          total_closing_cost: get_total_closing_cost(quote, lender_underwriting_fee, thirty_fees),
          nmls: lender_info[lender_name] ? lender_info[lender_name][:nmls] : nil,
          logo_url: lender_info[lender_name] ? lender_info[lender_name][:logo_url] : nil,
          commission: lender_info[lender_name] ? lender_info[lender_name][:commission].to_f : 0,
          loan_type: quote["ProductFamily"],
          discount_pts: discount_pts,
          pmi_monthly_premium_amount: quote["MIP"].to_f,
          is_cash_out: is_cash_out,
          is_down_payment: is_down_payment,
          loan_to_value: quote["LoanToValue"].to_f,
          fha_upfront_premium_amount: fha_upfront_premium_amount,
          lender_underwriting_fee: lender_underwriting_fee,
          lender_credits: lender_credits,
          lender_fee: lender_credits + lender_underwriting_fee + fha_upfront_premium_amount,
          thirty_fees: thirty_fees,
          prepaid_fees: prepaid_fees,
          total_prepaid_fees: prepaid_fees.map { |x| x[:FeeAmount] }.sum
        }

        programs << program
      end

      programs = build_characteristics(programs)
      programs.sort_by { |program| [program[:interest_rate], program[:apr]] }
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
        next if characteristics[program[:product]].nil?

        if program[:apr] == characteristics[program[:product]][:apr]
          program[:characteristic] = "Of all #{program[:product]} mortgages on MortgageClub that you've qualified for, this one has the lowest APR."
        elsif program[:interest_rate] == characteristics[program[:product]][:interest_rate]
          program[:characteristic] = "Of all #{program[:product]} mortgages on MortgageClub that you've qualified for, this one has the lowest rate."
        elsif program[:total_closing_cost] == characteristics[program[:product]][:total_closing_cost]
          program[:characteristic] = "Of all #{program[:product]} mortgages on MortgageClub that you've qualified for, this one has the lowest total closing cost."
        end
      end

      programs = programs.reject do |program|
        characteristics[program[:product]].nil? || (program[:apr] - characteristics[program[:product]][:apr] > 0.00625)
      end
    end

    def self.build_lowest_apr(quotes, loan_purpose, thirty_fees, property_value, is_cash_out = false, is_down_payment = false)
      programs = self.call(quotes, loan_purpose, thirty_fees, property_value)
      lowest_apr = {}
      [
        "30 year fixed", "15 year fixed",
        "7/1 ARM", "5/1 ARM"
      ].each do |type|
        filtered_programs = filter_programs_by_product_type(programs, type)
        lowest_apr[type] = get_lowest_program(filtered_programs, :apr)
      end
      lowest_apr
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

    def self.get_lowest_program(programs, type)
      return if programs.nil? || programs.empty?

      program = programs.first
      programs.each { |p| program = p if program[type] > p[type] }
      program
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
