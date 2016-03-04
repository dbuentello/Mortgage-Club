module Docusign
  class GenerateSignersForEnvelopeService
    attr_reader :loan, :templates, :envelope_hash

    def initialize(loan, templates, envelope_hash)
      @loan = loan
      @templates = templates
      @envelope_hash = envelope_hash
    end

    def call
      helper = Docusign::Helper.new(client: DocusignRest::Client.new)
      document_id = 1
      signers = []
      templates.each do |template|
        tabs = helper.get_tabs_from_template(
          {
            template_id: template.docusign_id,
            template_name: template.name,
            data: envelope_hash[:data].shift
          },
          document_id.to_s
        )
        signer = {
          embedded: envelope_hash[:embedded],
          name: envelope_hash[:user][:name],
          email: envelope_hash[:user][:email],
          role_name: 'Normal'
        }
        signer_2 = {
          embedded: envelope_hash[:embedded],
          name: loan.secondary_borrower.user.to_s,
          email: loan.secondary_borrower.user.email,
          role_name: 'Normal',
          sign_here_tabs: [
            {
              name: "Signature 3",
              page_number: "1",
              x_position: "323",
              y_position: "491",
              document_id: "1",
              optional: "true"
            }
          ]
        }
        document_id += 1
        signer.merge!(tabs)
        remove_co_signature(signer) unless envelope_requires_cosignature?(template)
        signers << signer
        signers << signer_2
      end
      signers
    end

    private

    def remove_co_signature(signer)
      signer[:sign_here_tabs].pop
      signer[:date_signed_tabs].pop
    end

    def envelope_requires_cosignature?(template)
      template.may_need_coapplicant_signature? && loan.secondary_borrower.present?
    end
  end
end
