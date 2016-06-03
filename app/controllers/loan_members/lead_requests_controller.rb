class LoanMembers::LeadRequestsController < LoanMembers::BaseController
  def index
    sent_requests = current_user.loan_member.lead_requests.sent

    bootstrap(
      loans: LoanMembers::LoansPresenter.new(Loan.new_loans).show,
      sent_requests: LoanMembers::LeadRequestsPresenter.new(sent_requests).show
    )

    respond_to do |format|
      format.html { render template: "loan_member_app" }
    end
  end

  def create
    request = LeadRequest.find_or_create_by(loan_id: params[:id], loan_member_id: current_user.loan_member.id)
    request.sent!

    LeadRequestsMailer.send_request(current_user, params[:id]).deliver_later

    sent_requests = current_user.loan_member.lead_requests.sent

    render json: {
      sent_requests: LoanMembers::LeadRequestsPresenter.new(sent_requests).show
    }, status: 200
  end
end
