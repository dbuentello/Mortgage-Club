class ElectronicSignatureController < ApplicationController
  before_action :set_loan, only: [:template]

  def template
    template = Template.where(name: params[:template_name]).first
    if template.blank?
      return render json: {
              message: "Template does not exist yet",
              details: "Template #{params[:template_name]} does not exist yet!"
            }, status: 500
    end

    envelope_response = Docusign::CreateEnvelopeService.new(current_user, @loan, template).call
    recipient_view = Docusign::GetRecipientViewService.call(envelope_response['envelopeId'], current_user, electronic_signature_embedded_response_url)

    if recipient_view
      render json: {message: recipient_view}, status: 200
    else
      render json: {message: "can't render iframe"}, status: 500
    end
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
