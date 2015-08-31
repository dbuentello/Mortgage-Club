class ElectronicSignatureController < ApplicationController
  before_action :set_loan, only: [:template]
  IS_EMBEDDED = true

  # POST
  def template
    current_loan = @loan || current_user.loans.first
    base = Docusign::Base.new

    # get Template info from database
    template = Template.where(name: params[:template_name]).first

    # handle none-existing template
    if template.blank?
      render json: {
          message: "Template does not exist yet",
          details: "Template #{params[:template_name]} does not exist yet!"
        }, status: :ok

      return
    end

    # Set values to tab labels
    if template.name == "Loan Estimate"
      values = Docusign::Templates::LoanEstimate.new(current_user.borrower, current_loan).params
    elsif template.name == "Servicing Disclosure"
      values = Docusign::Templates::ServicingDisclosure.new(current_user.borrower, current_loan).params
    end

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
        template_name: params[:template_name],
        template_id: template.docusign_id,
        email_subject: template.email_subject,
        email_body: template.email_body
      })
    else
      envelope_hash.merge!({
        template_name: params[:template_name],
        email_subject: "Electronic Signature Request from Mortgage Club",
        email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!"
      })
    end
    envelope_response = base.create_envelope_from_template(envelope_hash)

    # get envelope id to load appropriate view
    envelope_id = envelope_response["envelopeId"]

    if IS_EMBEDDED
      # request the view url to embedd to iframe
      view_response = base.client.get_recipient_view(
        envelope_id: envelope_id,
        name: current_user.to_s,
        email: current_user.email,
        return_url: electronic_signature_embedded_response_url
      )

      render json: {message: view_response}, status: :ok
    else
      render json: {message: "don't render iframe"}, status: :ok
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
