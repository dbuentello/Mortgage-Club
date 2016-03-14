class Users::LiabilitiesController < Users::BaseController
  before_action :set_loan, only: [:create]

  def create
    credit_report_id = @loan.borrower.credit_report.try(:id)
    @properties = LiabilityForm.new({
      loan_id: params[:loan_id],
      own_investment_property: params[:own_investment_property],
      credit_report_id: credit_report_id,
      subject_property: params[:subject_property],
      primary_property: params[:primary_property],
      rental_properties: params[:rental_properties]
    })

    if @properties.save
      render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show, liabilities: load_liabilities(@loan)}
    else
      render json: {message: "cannot save liabilities"}, status: 500
    end
  end

  private

  def load_liabilities(loan)
    credit_report = loan.borrower.credit_report
    credit_report.liabilities
  end
end