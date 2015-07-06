class ElectronicSignatureController < ApplicationController

  # POST
  def demo
    # Set values to tab labels
    # NOTE: need to map 2 names carefully (for example "Phone" will take value from :phone)
    # the JS name is from 'tooltip' of field in the template
    values = {
      "Your phone number" => current_user.borrower.phone
    }

    # get Template info from database
    base = Docusign::Base.new
    template = Template.where(name: "Loan Estimation").first
    current_loan = current_user.loans.first
    envelope = current_loan.envelope

    if envelope
      # get in progress envelope id stored in database to load appropriate view
      envelope_id = envelope.docusign_id
    else
      # create new envelope from template
      if template
        envelope_response = base.create_envelope_from_template(
          template_id: template.docusign_id,
          email_subject: template.email_subject,
          email_body: template.email_body,
          user: {
            name: current_user.to_s,
            email: current_user.email
          },
          values: values,
          embedded: true,
          loan_id: current_loan.id
        )
      else
        envelope_response = base.create_envelope_from_template(
          template_name: "Loan Estimation",
          email_subject: "Electronic Signature Request from Mortgage Club",
          email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!",
          user: {
            name: current_user.to_s,
            email: current_user.email
          },
          values: values,
          embedded: true,
          loan_id: current_loan.id
        )
      end

      # get envelope id to load appropriate view
      envelope_id = envelope_response["envelopeId"]
    end

    # request the view url to embedd to iframe
    view_response = base.client.get_recipient_view(
      envelope_id: envelope_id,
      name: current_user.to_s,
      email: current_user.email,
      return_url: electronic_signature_embedded_response_url
    )

    render json: { message: view_response }, status: :ok
  end

  # GET /electronic_signature/embedded_response
  def embedded_response
    utility = DocusignRest::Utility.new

    # ap params
    if params[:event] == "signing_complete"
      render :text => utility.breakout_path(root_path), content_type: 'text/html'
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render :text => utility.breakout_path(root_path(success: true)), content_type: 'text/html'
    end
  end

end
