require "quotes_formulas"

module LoanTekServices
  class GetDataForCashOutRefinance
    include QuotesFormulas
    attr_reader :property_value, :loan_amount, :zipcode, :original_interest_rate, :property_type

    PURCHASE_LOAN = 1
    CREDIT_SCORE = 740
    PRIMARY_RESIDENCE = 1
    THIRTY_YEAR_FIXED = "30yearFixed"

    def initialize(property_value, loan_amount, zipcode, original_interest_rate, property_type)
      @property_value = property_value.to_f
      @loan_amount = loan_amount.to_f
      @zipcode = zipcode.to_s
      @original_interest_rate = original_interest_rate.to_f
      @property_type = property_type
    end

    def call
      quotes = LoanTekServices::SendRequestToLoanTek.call(
        zipcode: zipcode,
        credit_score: CREDIT_SCORE,
        loan_purpose: PURCHASE_LOAN,
        loan_amount: loan_amount,
        loan_to_value: get_loan_to_value,
        property_usage: PRIMARY_RESIDENCE,
        property_type: get_property_type,
        cash_out: true
      )

      return if quotes.empty?

      quotes = get_valid_quotes(quotes)
      quotes.sort! { |quote, another_quote| quote["APR"] <=> another_quote["APR"] }
      desired_quote = nil

      # loop the quotes to find desired quote
      quotes.each do |quote|
        if desired_quote?(quote)
          desired_quote = quote
          break
        end
      end

      return unless desired_quote

      admin_fee = get_admin_fee(desired_quote)

      {
        new_interest_rate_cash_out: get_interest_rate(desired_quote),
        estimated_closing_costs_cash_out: get_total_closing_cost(desired_quote, admin_fee),
        lender_credit_cashout: get_lender_credits(desired_quote, admin_fee)
      }
    end

    private

    def get_property_type
      case property_type
      when "sfh"
        1
      when "duplex"
        11
      when "triplex"
        12
      when "fourplex"
        13
      else
        0
      end
    end

    def get_loan_to_value
      (loan_amount * 100 / property_value).round(3)
    end

    def desired_quote?(quote)
      return false if quote["ProductName"] != THIRTY_YEAR_FIXED

      admin_fee = get_admin_fee(quote)
      interest_rate = get_interest_rate(quote)
      total_closing_cost = get_total_closing_cost(quote, admin_fee)

      interest_rate <= original_interest_rate && total_closing_cost <= 0
    end
  end
end
