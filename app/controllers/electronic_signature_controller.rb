class ElectronicSignatureController < ApplicationController
  IS_EMBEDDED = true

  # POST
  def demo
    current_loan = current_user.loans.first
    base = Docusign::Base.new

    # get the template name
    template_name = "Loan Estimation"
    # get Template info from database
    template = Template.where(name: template_name).first

    if (envelope = current_loan.envelope)
      # get in progress envelope id stored in database to load appropriate view
      envelope_id = envelope.docusign_id
    else
      # Set values to tab labels
      values = Docusign::Templates::LoanEstimation.get_values_mapping_hash(current_user, current_loan)

      if IS_EMBEDDED
        envelope_hash = {
          user: {
            name: current_user.to_s,
            email: current_user.email
          },
          values: values,
          embedded: true,
          loan_id: current_loan.id
        }
      else
        envelope_hash = {
          user: {
            name: "Billy",
            email: "billy@mortgageclub.io"
          },
          values: values,
          loan_id: current_loan.id
        }
      end

      # create new envelope from template
      if template
        envelope_hash.merge!({
          template_name: template_name,
          template_id: template.docusign_id,
          email_subject: template.email_subject,
          email_body: template.email_body
        })
      else
        envelope_hash.merge!({
          template_name: template_name,
          email_subject: "Electronic Signature Request from Mortgage Club",
          email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!"
        })
      end

      envelope_response = base.create_envelope_from_template(envelope_hash)

      # get envelope id to load appropriate view
      envelope_id = envelope_response["envelopeId"]
    end

    if IS_EMBEDDED
      # request the view url to embedd to iframe
      view_response = base.client.get_recipient_view(
        envelope_id: envelope_id,
        name: current_user.to_s,
        email: current_user.email,
        return_url: electronic_signature_embedded_response_url
      )

      render json: { message: view_response }, status: :ok
    else
      render json: { message: "success" }, status: :ok
    end
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
