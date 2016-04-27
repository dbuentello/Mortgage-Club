require "finance_formulas"

module RefinanceProposalServices
  class AutomateRefinanceProposal
    include FinanceFormulas
    attr_accessor :old_loan_amount, :periods, :original_loan_date,
                  :lender_credit, :estimated_closing_costs,
                  :old_interest_rate, :new_interest_rate, :start_due_date,
                  :current_home_value
    LTV = 0.8

    # periods: must be converted to months
    # number_of_months: for instance, I want to get loan amount of the tenth month.
    def initialize(args)
      @old_loan_amount = args[:old_loan_amount].to_f
      @periods = args[:periods].to_f
      @new_interest_rate = args[:new_interest_rate].to_f / 12
      @lender_credit = args[:lender_credit].to_f
      @estimated_closing_costs = args[:estimated_closing_costs].to_f
      @current_home_value = args[:current_home_value].to_f
      @original_loan_date = args[:original_loan_date]
      @old_interest_rate = args[:original_interest_rate] / 12
      @start_due_date = (Time.zone.now + 61.days).beginning_of_month
    end

    def call
      {
        current_mortgage_balance: current_mortgage_balance,
        current_monthly_payment: get_monthly_payment(old_interest_rate, old_loan_amount),
        new_monthly_payment: get_monthly_payment(new_interest_rate, new_loan_amount),
        net_closing_costs: net_closing_costs,
        savings_1_year: savings_in_one_year,
        savings_3_years: savings_in_three_years,
        savings_10_years: savings_in_ten_years,
        cash_out: cash_out,
        net_closing_costs: net_closing_costs,
        monthly_payment_for_cash_out: monthly_payment_for_cash_out,
        original_interest_rate: original_interest_rate
      }
    end

    # rate is monthly rate. It should be divided by 12
    def ending_balance(rate, amount, number_of_months = nil)
      number_of_months ||= periods
      monthly_payment = get_monthly_payment(rate, amount)
      ending_balance = amount

      number_of_months.times do
        ending_balance = ending_balance * (1 + rate) - monthly_payment
      end

      ending_balance.round(2)
    end

    def current_mortgage_balance
      # -1 because we want to get loan_balance which is a previous ending_balance
      start_date = (original_loan_date + 60.days).beginning_of_month
      number_of_months = get_number_of_months(start_date, Time.zone.now) - 1
      ending_balance(old_interest_rate, old_loan_amount, number_of_months)
    end

    def get_monthly_payment(rate, amount)
      (-pmt(rate, periods, amount)).round(2)
    end

    def original_lock_in_date
      original_loan_date - 30.days
    end

    def new_loan_amount
      current_mortgage_balance
    end

    def new_loan_start_date
      # 5/7/2016
      @new_loan_start_date ||= (Time.zone.now + 31.days).strftime('%m/%d/%Y')
    end

    def net_closing_costs
      lender_credit + estimated_closing_costs
    end

    def total_interest(rate, amount, number_of_months = nil)
      number_of_months ||= periods
      monthly_payment = get_monthly_payment(rate, amount)
      ending_balance = amount
      total_interest = 0

      number_of_months.times do
        total_interest += ending_balance * rate
        ending_balance = ending_balance * (1 + rate) - monthly_payment
      end

      total_interest.round(2)
    end

    def get_savings(end_due_date)
      original_start_due_date = (original_loan_date + 60.days).beginning_of_month
      savings = total_interest(old_interest_rate, old_loan_amount, get_number_of_months(original_start_due_date, end_due_date)) -
                total_interest(old_interest_rate, old_loan_amount, get_number_of_months(original_start_due_date, start_due_date)) -
                total_interest(new_interest_rate, new_loan_amount, get_number_of_months(start_due_date + 30.days, end_due_date)) -
                net_closing_costs

      savings.round(0)
    end

    def savings_in_one_year
      end_due_date = start_due_date + 12.months
      get_savings(end_due_date)
    end

    def savings_in_three_years
      end_due_date = start_due_date + 36.months
      get_savings(end_due_date)
    end

    def savings_in_ten_years
      end_due_date = start_due_date + 120.months
      get_savings(end_due_date)
    end

    def get_number_of_months(start_date, end_date)
      ((end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)) + 1
    end

    def loan_amount_for_cash_out
      current_home_value.to_f * LTV
    end

    def cash_out
      loan_amount_for_cash_out - current_mortgage_balance
    end

    def monthly_payment_for_cash_out
      get_monthly_payment(new_interest_rate, loan_amount_for_cash_out)
    end
  end
end
