require 'open-uri'

module Docusign
  class CreateEnvelopeService
    attr_accessor :user, :loan, :client, :helper, :templates

    def initialize(user, loan, templates)
      @user = user
      @loan = loan
      @templates = templates
      @client = DocusignRest::Client.new
      @helper = Docusign::Helper.new(client: @client)
    end

    def call
      @envelope_hash = build_envelope_hash
      signers = Docusign::GenerateSignersForEnvelopeService.new(loan, templates, @envelope_hash).call

      envelope_response = client.create_envelope_from_template(
        status: 'sent',
        email: {
          subject: "The test email subject envelope",
          body: "Envelope body content here"
        },
        template_id: "ee4df9c1-80fd-408b-b791-334a1b75d01d",
        signers: signers
      )

      # envelope_response = client.create_envelope_from_composite_template(
      #   status: 'sent',
      #   email: {
      #     subject: @envelope_hash[:email_subject],
      #     body: @envelope_hash[:email_body]
      #   },
      #   server_template_ids: template_ids,
      #   signers: signers
      # )

      if envelope_response["errorCode"].nil?
        save_envelope_object_into_database(envelope_response["envelopeId"], @envelope_hash[:loan_id])
        return envelope_response
      end
    end

    private

    def build_envelope_hash
      envelope_hash = {
        user: {name: user.to_s, email: user.email},
        data: mapping_value,
        loan_id: loan.id,
        embedded: true,
        email_subject: "Electronic Signature Request from Mortgage Club",
        email_body: "As discussed, let's finish our contract by signing to this envelope. Thank you!"
      }
    end

    def template_ids
      templates.map { |template| template.docusign_id }
    end

    def mapping_value
      templates.map do |template|
        template.template_mapping.new(loan).build
      end
    end

    def save_envelope_object_into_database(envelope_id, loan_id)
      envelope = Envelope.find_or_initialize_by(
        loan_id: loan_id
      )
      envelope.docusign_id = envelope_id
      envelope.save
    end
  end
end

#{"errorCode"=>"INVALID_REQUEST_PARAMETER", "message"=>"The request contained at least one invalid parameter. 'recipientId' not set for recipient."}