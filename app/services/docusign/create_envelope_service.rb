require 'open-uri'

module Docusign
  class CreateEnvelopeService
    attr_accessor :user, :loan, :client, :helper, :template, :template_mapping, :envelope_hash

    def initialize(user, loan, template)
      @user = user
      @loan = loan
      @template = template
      @template_mapping = template.template_mapping
      @client = DocusignRest::Client.new
      @helper = Docusign::Helper.new(client: @client)
      @envelope_hash = build_envelope_hash
    end

    def call
      return Rails.logger.error "Error: don't have enough params" if template_blank?

      envelope_response = client.create_envelope_from_document(
        status: 'sent',
        email: {
          subject: envelope_hash[:email_subject],
          body: envelope_hash[:email_body]
        },
        template_id: envelope_hash[:template_id],
        signers: build_signers,
        files: [
          build_file
        ]
      )

      save_envelope_object_into_database(envelope_response["envelopeId"], envelope_hash[:template_id], envelope_hash[:loan_id])
      envelope_response
    end

    private

    def build_envelope_hash
      envelope_hash = {
        user: {name: user.to_s, email: user.email},
        values: mapping_value,
        embedded: true,
        loan_id: loan.id,
        template_name: template.name,
        template_id: template.docusign_id,
        email_subject: template.email_subject || "The test email subject envelope",
        email_body: template.email_body || "Envelope body content here"
      }
      envelope_hash = helper.make_sure_template_name_and_id_exist(envelope_hash)
    end

    def mapping_value
      template_mapping.new(loan).params
    end

    def build_signers
      signers = []
      tabs = helper.get_tabs_from_template(
        template_id: envelope_hash[:template_id], template_name: envelope_hash[:template_name],
        values: envelope_hash[:values]
      )
      signer = {
        embedded: envelope_hash[:embedded],
        name: envelope_hash[:user][:name],
        email: envelope_hash[:user][:email],
        role_name: 'Normal'
      }
      signer = signer.merge(tabs)
      signers << signer
    end

    def build_file
      if envelope_hash[:document]
        # envelope_hash[:document] ||= Documents::FirstW2.first
        file_url = Amazon::GetUrlService.call(envelope_hash[:document].attachment, 3.minutes)
        file_io = open(file_url)
        file = {io: file_io, name: envelope_hash[:document].attachment.instance.attachment_file_name}
      else
        file_url = "#{Rails.root}/vendor/files/templates/#{envelope_hash[:template_name]}.pdf"
        file = {path: file_url, name: "#{envelope_hash[:template_name]}.pdf"}
      end
      file
    end

    def save_envelope_object_into_database(envelope_id, template_id, loan_id)
      envelope = Envelope.find_or_initialize_by(
        template_id: template_id,
        loan_id: loan_id
      )
      envelope.docusign_id = envelope_id
      envelope.save
    end

    def template_blank?
      envelope_hash[:template_id].blank? && envelope_hash[:template_name].blank?
    end
  end
end