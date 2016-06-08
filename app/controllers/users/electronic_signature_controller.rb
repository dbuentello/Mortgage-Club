#
# Class Users::ElectronicSignatureController provides methods for borrower to signs into document
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
class Users::ElectronicSignatureController < Users::BaseController
  before_action :set_loan, only: [:new, :create, :embedded_response]

  #
  # Show loading page to get document from Docusign
  #
  # @return [HTML] borrower app with bootstrap data includes loan and selected rate
  #
  def new
    bootstrap(
      loan: LoanDashboardPage::LoanPresenter.new(@loan).show,
      rate: params[:rate]
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  #
  # Update loan data from selected rate, call Docusign to get document for borrower signs into
  #
  # @return [HTML] document view
  #
  def create
    return render nothing: true, status: 200 if Rails.env.test?

    RateServices::UpdateLoanDataFromSelectedRate.call(params[:id], params[:fees], lender_params)
    @loan.reload

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
      render json: {message: t("errors.iframe_render_error")}, status: 500
    end
  end

  # GET /electronic_signature/embedded_response
  #
  # Callback Docusign will be called after borrower signs completely.
  #
  # @return [HTML] loans dashboard of borrower
  # If loan has co-borrower, this function return a document view for co-borrower signs into
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
      # TODO: why call two services below:
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
      :lender_credits, :apr,
      :loan_type, :total_closing_cost
    )
  end
end
