#
# Class Users::LiabilitiesController provides create method to update liabilities of property
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
class Users::LiabilitiesController < Users::BaseController
  before_action :set_loan, only: [:create]

  def create
    credit_report_id = @loan.borrower.credit_report.try(:id)
    @properties = LiabilityForm.new(
      loan_id: params[:loan_id],
      own_investment_property: params[:own_investment_property],
      credit_report_id: credit_report_id,
      subject_property: params[:subject_property],
      primary_property: params[:primary_property],
      rental_properties: params[:rental_properties]
    )

    if @properties.save
      render json: {loan: LoanEditPage::LoanPresenter.new(@loan.reload).show, liabilities: load_liabilities(@loan.reload)}
    else
      render json: {message: t("users.liabilities.create.failed")}, status: 500
    end
  end

  private

  def load_liabilities(loan)
    credit_report = loan.borrower.credit_report
    credit_report.liabilities
  end
end
