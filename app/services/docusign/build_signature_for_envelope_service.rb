module Docusign
  class BuildSignatureForEnvelopeService
    attr_reader :loan, :templates, :envelope_hash

    def initialize(loan, templates, envelope_hash)
      @loan = loan
      @templates = templates
      @envelope_hash = envelope_hash
    end

    def call
      helper = Docusign::Helper.new(client: DocusignRest::Client.new)
      document_id = 1
      templates.map do |template|
        tabs = helper.get_tabs_from_template(
          {template_id: template.docusign_id, template_name: template.name, data: envelope_hash[:data].shift},
          document_id.to_s
        )
        signer = {
          embedded: envelope_hash[:embedded],
          name: envelope_hash[:user][:name],
          email: envelope_hash[:user][:email],
          role_name: 'Normal'
        }
        document_id += 1
        signer.merge!(tabs)
        build_cosignature(signer, template) if envelope_requires_cosignature?(template)
        align_tabs(signer, template)
        signer
      end
    end

    private

    def build_cosignature(signer, template)
      signer[:sign_here_tabs] << template.cosignature_position
      signer[:date_signed_tabs] << template.codate_signed_position
    end

    def envelope_requires_cosignature?(template)
      template.may_need_coapplicant_signature? && loan.secondary_borrower.present?
    end

    def align_tabs(signer, template)
      template.template_alignment.new(signer).call
    end
  end
end
