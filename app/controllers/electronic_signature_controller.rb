class ElectronicSignatureController < ApplicationController
  before_action :set_loan, only: [:new, :create]

  def new
    bootstrap({
      loan: LoanPresenter.new(@loan).show
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def create
    templates = Template.where(name: ["Loan Estimate", "Servicing Disclosure"])
    if templates.empty?
      return render json: {
              message: "Template does not exist yet",
              details: "Template #{params[:template_name]} does not exist yet!"
            }, status: 500
    end

    envelope = Docusign::CreateEnvelopeService.new(current_user, @loan, templates).call
    if envelope
      recipient_view = Docusign::GetRecipientViewService.call(
        envelope['envelopeId'],
        current_user,
        embedded_response_electronic_signature_index_url
      )
      return render json: {message: recipient_view}, status: 200 if recipient_view
    end

    render json: {message: "can't render iframe"}, status: 500
  end

  # GET /electronic_signature/embedded_response
  def embedded_response
    utility = DocusignRest::Utility.new

    # ap params
    if params[:event] == "signing_complete"
      render :text => utility.breakout_path(borrower_root_path), content_type: 'text/html'
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render :text => utility.breakout_path(borrower_root_path(success: true)), content_type: 'text/html'
    end
  end
end
