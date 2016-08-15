# get data for Refinance Proposal (for Facebook Bot).
require "quotes_formulas"

module LoanTekServices
  class GetDataForRefinanceProposal
    include QuotesFormulas
    attr_reader :property_value, :loan_amount, :zipcode,
                :original_interest_rate, :property_type, :cash_out

    PURCHASE_LOAN = "Purchase"
    CREDIT_SCORE = 740
    PRIMARY_RESIDENCE = "PrimaryResidence"
    THIRTY_YEAR_FIXED = "30yearFixed"

    def initialize(args)
      @property_value = args[:property_value].to_f
      @loan_amount = args[:loan_amount].to_f
      @zipcode = args[:zipcode].to_s
      @original_interest_rate = args[:original_interest_rate].to_f
      @property_type = args[:property_type]
      @cash_out = args[:cash_out]
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
        cash_out: cash_out
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
        interest_rate: get_interest_rate(desired_quote),
        estimated_closing_costs: get_total_closing_cost(desired_quote, admin_fee),
        lender_credit: get_lender_credits(desired_quote, admin_fee)
      }
    end

    private

    def get_property_type
      case property_type
      when "sfh"
        property_type = "SingleFamily"
      when "duplex"
        property_type = "MultiFamily2Units"
      when "triplex"
        property_type = "MultiFamily3Units"
      when "fourplex"
        property_type = "MultiFamily4Units"
      else
        property_type = "NotSpecified"
      end
      property_type
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
