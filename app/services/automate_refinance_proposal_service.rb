require "finance_formulas"

class AutomateRefinanceProposalService
  attr_accessor :loan_amount, :apr, :periods, :original_loan_date,
                :lender_credit, :estimated_closing_costs, :new_interest_rate
  # original_lock_in_date = original_loan_date - 30.days
  # avg_rate = vlookup "Historical Mortgage Rate" / 100
  # original_interest_rate = round((avg_rate + lender_avg_overlay) / 0.125) * 0.125
  # current_mortgage_balance = ending_balance(a day before) - total_principal_payment
  # total_principal_payment = bonus_payment + extra_regular_payment + principal
  # interest = ending_balance(a day before) * (annual_interest_rate / 12)
  # current_monthly_payment = -pmt(original_interest_rate / 12, original_term * 12, loan_amount)
  # cumulative_interest = SUM(interest) from start date to end date

  # LOWER RATE REFINANCE
  # net_closing_costs = estimated_closing_costs + lender_credit
  # new_monthly_payment = -pmt(loan_tek_rate / 12, original_term * 12, current_mortgage_balance)

  # apr: It's monthly apr so if it's annual apr, it must be divided into 12
  # periods: must be converted to months
  # number_of_months: for instance, I want to get loan amount of the tenth month.
  LENDER_AVG_OVERLAY = 0.0025

  def initialize
    # DateTime.strptime('03/25/2010 14:25:00', '%m/%d/%Y %H:%M:%S')
  end

  def ending_balance(number_of_months = nil)
    ending_balance = 0
    number_of_months ||= periods
    number_of_months.times do |period|
      ending_balance = loan_amount * (1 + apr) - current_monthly_payment
    end
    ending_balance
  end

  def current_mortgage_balance
    @current_mortgage_balance ||= begin
      # -1 because we want to get loan_balance which is a previous ending_balance
      number_of_months = get_number_of_months(Time.zone.now, original_loan_date)
      ending_balance(number_of_months)
    end
  end

  def current_monthly_payment
    @current_monthly_payment ||= -pmt(apr, periods, loan_amount)
  end

  def new_monthly_payment
    @new_monthly_payment ||= -pmt(new_interest_rate, periods, new_loan_amount)
  end

  def original_lock_in_date
    original_loan_date - 30.days
  end

  def original_interest_rate
    ((avg_rate_lock_in_date + LENDER_AVG_OVERLAY) / 0.00125) * 0.00125
  end

  def avg_rate_lock_in_date
    # query from Model with
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

  def get_savings(end_due_date)
    start_due_date = (Time.zone.now + 61.days).beginning_of_month
    original_start_due_date = (original_loan_date + 60.days).beginning_of_month
    ending_balance(get_number_of_months(end_due_date, original_start_due_date)) - ending_balance(get_number_of_months(start_due_date, original_start_due_date)) -
      ending_balance(get_number_of_months(end_due_date, start_due_date)) - net_closing_costs
  end

  def savings_in_one_year
    end_due_date = start_due_date + 11.months
    get_savings(end_due_date)
  end

  def savings_in_three_years
    end_due_date = start_due_date + 33.months
    get_savings(end_due_date)
  end

  def savings_in_three_years
    end_due_date = start_due_date + 110.months
    get_savings(end_due_date)
  end

  def get_number_of_months(end_date, start_date)
    Time.at(end_date.to_time - start_date.to_time).month + 1
  end
end

ending_balance = loan_amount - SUM(total_principal_payment)