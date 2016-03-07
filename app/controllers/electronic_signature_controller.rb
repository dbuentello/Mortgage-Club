class ElectronicSignatureController < ApplicationController
  before_action :set_loan, only: [:new, :create, :embedded_response]

  def new
    bootstrap({
      loan: LoanDashboardPage::LoanPresenter.new(@loan).show,
      rate: params[:rate]
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def create
    # templates = Template.where(name: ["Uniform Residential Loan Application"])

    # if templates.empty?
    #   return render json: {
    #           message: "Template does not exist yet",
    #           details: "Template #{params[:template_name]} does not exist yet!"
    #         }, status: 500
    # end

    envelope = Docusign::CreateEnvelopeService.new.call(current_user, @loan)
    recipient_view = DocusignRest::Client.new.get_recipient_view(
      envelope_id: envelope['envelopeId'],
      name: "#{current_user.first_name} #{current_user.last_name}",
      email: current_user.email,
      return_url: embedded_response_electronic_signature_index_url(
        loan_id: params[:id],
        envelope_id: envelope['envelopeId'],
        user_id: current_user.id
      )
    )

    if recipient_view
      render json: {message: recipient_view}, status: 200
    else
      render json: {message: "can't render iframe"}, status: 500
    end
  end

  # GET /electronic_signature/embedded_response
  def embedded_response
    utility = DocusignRest::Utility.new

    if params[:event] == "signing_complete"
      if @loan.secondary_borrower && @loan.secondary_borrower.user.id != params[:user_id]
        recipient_view = DocusignRest::Client.new.get_recipient_view(
          envelope_id: params[:envelope_id],
          name: "#{@loan.secondary_borrower.user.first_name} #{@loan.secondary_borrower.user.last_name}",
          email: @loan.secondary_borrower.user.email,
          return_url: embedded_response_electronic_signature_index_url(
            loan_id: params[:loan_id],
            envelope_id: params[:envelope_id],
            user_id: @loan.secondary_borrower.user.id
          )
        )

        return redirect_to recipient_view["url"] if recipient_view
      end

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
    params.require(:lender).permit(
      :interest_rate, :lender_name, :lender_nmls_id,
      :period, :amortization_type, :monthly_payment,
      :apr, :loan_type, :total_closing_cost
    )
  end
end
