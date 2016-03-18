class LoanMembers::SubmissionsController < LoanMembers::BaseController
  before_action :set_loan, only: [:submit_to_lender, :get_email_info]

  def submit_to_lender
    service = SubmissionServices::SubmitApplicationToLender.new(
      @loan, current_user, params[:email_subject], params[:email_content]
    )

    if service.call
      @loan.conditionally_approved!
      return render json: {message: t("loan_members.submissions.submit_to_lender.success")}, status: 200
    else
      return render json: {message: service.error_message}, status: 500
    end
  end

  def get_email_info
    info = SubmissionServices::GetEmailInfo.new(@loan, current_user.loan_member, current_user).call

    render json: {info: info}, status: 200
  end
end
