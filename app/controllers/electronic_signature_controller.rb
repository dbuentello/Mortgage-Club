class ElectronicSignatureController < ApplicationController

  # POST
  def demo
    # Set values to tab labels
    # NOTE: need to map 2 names carefully (for example "Phone" will take value from :phone)
    # the JS name is from 'tooltip' of field in the template
    values = {
      "Your phone number" => current_user.borrower.phone
    }

    base = Docusign::Base.new
    response = base.create_envelope_from_template(
      template_name: "Loan Estimation",
      email_subject: "Electronic Signature Request from Mortgage Club",
      email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!",
      user: {
        name: current_user.to_s,
        email: current_user.email
      },
      values: values,
      embedded: true
    )

    view_response = base.client.get_recipient_view(
      envelope_id: response["envelopeId"],
      name: current_user.to_s,
      email: current_user.email,
      return_url: "http://localhost:4000/electronic_signature/embedded_response"
    )

    render json: { message: view_response }, status: :ok
  end

  # GET /electronic_signature/embedded_response
  def embedded_response
    utility = DocusignRest::Utility.new

    ap params

    if params[:event] == "signing_complete"
      render :text => utility.breakout_path(root_path), content_type: 'text/html'
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render :text => utility.breakout_path(root_path(success: true)), content_type: 'text/html'
    end
  end

end
