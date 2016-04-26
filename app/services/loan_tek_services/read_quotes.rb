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

        next if existing_program?(programs, apr, rate, lender_name, discount_pts, product)

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
  end
end
