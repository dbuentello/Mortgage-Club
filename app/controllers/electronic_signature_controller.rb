class ElectronicSignatureController < ApplicationController
  before_action :set_loan, only: [:new, :create, :embedded_response]

  def new
    bootstrap({
      loan: LoanDashboardPage::LoanPresenter.new(@loan).show,
      rate: params[:rate],
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def create
    templates = Template.where(name: ["Loan Estimate", "Servicing Disclosure", "Uniform Residential Loan Application"])
    if templates.empty?
      return render json: {
              message: "Template does not exist yet",
              details: "Template #{params[:template_name]} does not exist yet!"
            }, status: 500
    end

    # TODO: only update loan's data after user signed contract
    RateServices::UpdateLoanDataFromSelectedRate.call(params[:id], params[:fees], lender_params)
    @loan.reload

    envelope = Docusign::CreateEnvelopeService.new(current_user, @loan, templates).call

    if envelope
      recipient_view = Docusign::GetRecipientViewService.call(
        envelope['envelopeId'],
        current_user,
        embedded_response_electronic_signature_index_url(
          loan_id: params[:id],
          envelope_id: envelope['envelopeId'],
          user_id: current_user.id
        )
      )
      return render json: {message: recipient_view}, status: 200 if recipient_view
    end

    render json: {message: "can't render iframe"}, status: 500
  end

  # GET /electronic_signature/embedded_response
  def embedded_response
    utility = DocusignRest::Utility.new

    if params[:event] == "signing_complete"
      @loan.submitted!
      Docusign::MapEnvelopeToLenderDocument.new(params[:envelope_id], params[:user_id], params[:loan_id]).delay.call
      RatesComparisonServices::Base.new(params[:loan_id], params[:user_id]).call
      render text: utility.breakout_path("/my/dashboard/#{params[:loan_id]}"), content_type: 'text/html'
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render text: utility.breakout_path("/my/dashboard/#{params[:loan_id]}"), content_type: 'text/html'
    end
  end

  private

  def lender_params
    params.require(:lender).permit(:interest_rate, :name, :lender_nmls_id, :period, :amortization_type, :monthly_payment, :apr)
  end
end
