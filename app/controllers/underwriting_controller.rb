class UnderwritingController < ApplicationController
  def index
    @loan = Loan.find(params[:loan_id])

    return redirect_to edit_loan_url(@loan) unless @loan.completed?

    bootstrap({
      currentLoan: LoanEditPage::LoanPresenter.new(@loan).show,
    })
    render template: "borrower_app"
  end

  def check_loan
    @loan = Loan.find(params[:loan_id])
    service = UnderwritingLoanServices::UnderwriteLoan.new(@loan)
    service.call
    if service.valid_loan?
      render json: {message: t("messages.status.ok")}
    else
      render json: {message: t("messages.status.error"), errors: service.error_messages, debug_info: get_debug_info}
    end
  end

  # for debug purpose, it'll be removed in future
  def get_debug_info
    return {} unless @loan.borrower.credit_report

    borrower = @loan.borrower
    subject_property = @loan.subject_property
    properties = @loan.properties.map do |property|
      {
        is_subject: subject_property.id == property.id ? 1 : 0,
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
      sum_liability_payment: borrower.credit_report.sum_liability_payment,
      sum_investment: UnderwritingLoanServices::CalculateDebtToIncome.sum_investment(@loan.rental_properties),
      primary_liability_payments: subject_property.liability_payments,
      primary_estimated_mortgage_insurance: subject_property.estimated_mortgage_insurance.to_f,
      primary_estimated_hazard_insurance: subject_property.estimated_hazard_insurance.to_f,
      primary_estimated_property_tax: subject_property.estimated_property_tax.to_f,
      primary_hoa_due: subject_property.hoa_due.to_f,
      total_income: UnderwritingLoanServices::CalculateTotalIncome.call(@loan),
      rental_income: UnderwritingLoanServices::CalculateRentalIncome.call(@loan),
      current_salary: borrower.current_salary,
      gross_overtime: borrower.gross_overtime.to_f,
      gross_commission: borrower.gross_commission.to_f,
      properties: properties
    }
  end
end
