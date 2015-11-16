class RatesController < ApplicationController
  def index
    @loan = Loan.find(params[:loan_id])
    rates = []

    if @loan.primary_property.address && zipcode = @loan.primary_property.address.zip
      rates = ZillowService::GetMortgageRates.new(@loan.id, zipcode).call
    end

    bootstrap({
      currentLoan: LoanPresenter.new(@loan).edit,
      rates: rates,
      debug_info: get_debug_info
    })

    render template: 'borrower_app'
  end

  # for debug purpose, it'll be removed in future
  def get_debug_info
    borrower = @loan.borrower
    primary_property = @loan.primary_property
    properties = @loan.properties.map do |property|
      {
        is_primary: primary_property.id == property.id ? 1 : 0,
        liability_payments: property.liability_payments,
        mortgage_payment: property.mortgage_payment,
        other_financing: property.other_financing,
        actual_rental_income: property.actual_rental_income,
        estimated_property_tax: property.estimated_property_tax,
        estimated_hazard_insurance: property.estimated_hazard_insurance,
        estimated_mortgage_insurance: property.estimated_mortgage_insurance,
        hoa_due: property.hoa_due,
      }
    end

    {
      credit_score: borrower.credit_score,
      debt_to_income: UnderwritingLoanServices::CalculateDebtToIncome.call(@loan),
      housing_expense: UnderwritingLoanServices::CalculateHousingExpenseRatio.call(@loan),
      sum_liability_payment: UnderwritingLoanServices::CalculateDebtToIncome.sum_liability_payment(@loan.properties),
      sum_investment: UnderwritingLoanServices::CalculateDebtToIncome.sum_investment(@loan.rental_properties),
      primary_liability_payments: primary_property.liability_payments,
      primary_estimated_mortgage_insurance: primary_property.estimated_mortgage_insurance.to_f,
      primary_estimated_hazard_insurance: primary_property.estimated_hazard_insurance.to_f,
      primary_estimated_property_tax: primary_property.estimated_property_tax.to_f,
      primary_hoa_due: primary_property.hoa_due.to_f,
      total_income: UnderwritingLoanServices::CalculateTotalIncome.call(@loan),
      rental_income: UnderwritingLoanServices::CalculateRentalIncome.call(@loan),
      current_salary: borrower.current_salary,
      gross_overtime: borrower.gross_overtime.to_f,
      gross_commission: borrower.gross_commission.to_f,
      properties: properties
    }
  end
end
