require 'open-uri'

module Docusign
  class CreateEnvelopeService
    attr_accessor :user, :loan, :client, :helper, :template, :template_mapping

    def initialize(user, loan, template)
      @user = user
      @loan = loan
      @template = template
      @template_mapping = template.template_mapping
      @client = DocusignRest::Client.new
      @helper = Docusign::Helper.new(client: @client)
    end

    def call
      @envelope_hash = build_envelope_hash
      signers = Docusign::BuildSignatureForEnvelopeService.new(loan, template, @envelope_hash).call
      envelope_response = client.create_envelope_from_document(
        status: 'sent',
        email: {
          subject: @envelope_hash[:email_subject],
          body: @envelope_hash[:email_body]
        },
        template_id: @envelope_hash[:template_id],
        signers: signers,
        files: [
          build_file
        ]
      )
      save_envelope_object_into_database(envelope_response["envelopeId"], @envelope_hash[:template_id], @envelope_hash[:loan_id])
      envelope_response
    end

    private

    def build_envelope_hash
      envelope_hash = {
        user: {name: user.to_s, email: user.email},
        data: mapping_value,
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

    def build_file
      if @envelope_hash[:document]
        # @envelope_hash[:document] ||= Documents::FirstW2.first
        file_url = Amazon::GetUrlService.call(@envelope_hash[:document].attachment, 3.minutes)
        file_io = open(file_url)
        file = {io: file_io, name: @envelope_hash[:document].attachment.instance.attachment_file_name}
      else
        file_url = "#{Rails.root}/vendor/files/templates/#{@envelope_hash[:template_name]}.pdf"
        file = {path: file_url, name: "#{@envelope_hash[:template_name]}.pdf"}
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
  end
end