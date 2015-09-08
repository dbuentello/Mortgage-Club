module Docusign
  class BuildSignatureForEnvelopeService
    attr_reader :loan, :template, :envelope_hash

    def initialize(loan, template, envelope_hash)
      @loan = loan
      @template = template
      @envelope_hash = envelope_hash
    end

    def call
      helper = Docusign::Helper.new(client: DocusignRest::Client.new)
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
      build_cosignature(signer) if envelope_requires_cosignature?
      signers << signer
    end

    private

    def build_cosignature(signer)
      signer[:sign_here_tabs] << template.cosignature_position
      signer[:date_signed_tabs] << template.codate_signed_position
    end

    def envelope_requires_cosignature?
      template.may_need_coapplicant_signature? && loan.secondary_borrower.present?
    end
  end
end
