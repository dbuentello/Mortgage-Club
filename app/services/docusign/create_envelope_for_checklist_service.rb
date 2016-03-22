require "pdf_forms"

module Docusign
  class CreateEnvelopeForChecklistService
    CHECKLIST_FORM_PATH = "#{Rails.root}/form_templates/generic_explanation.pdf".freeze
    CHECKLIST_FORM_OUTPUT_PATH = "#{Rails.root}/tmp/generic_explanation.pdf".freeze

    attr_accessor :pdftk

    def initialize
      @pdftk = PdfForms.new(ENV.fetch("PDFTK_BIN", "/usr/local/bin/pdftk"))
    end

    def call(user, loan)
      data = Docusign::Templates::GenericExplanation.new(loan).build
      pdftk.get_field_names(CHECKLIST_FORM_PATH)
      pdftk.fill_form(CHECKLIST_FORM_PATH, "tmp/generic_explanation.pdf", data)

      client = DocusignRest::Client.new
      envelope = client.create_envelope_from_document(
        status: "sent",
        email: {
          subject: I18n.t("services.docusign.create_envelope_for_checklist_service.envelope_email_subject")
        },
        files: [
          {path: CHECKLIST_FORM_OUTPUT_PATH}
        ],
        signers: [
          {
            embedded: true,
            name: "#{user.first_name} #{user.last_name}",
            email: user.email,
            role_name: "Normal",
            sign_here_tabs: [
              {
                name: "Signature",
                page_number: 1,
                x_position: 17,
                y_position: 390,
                document_id: 1,
                optional: "false"
              }
            ],
            text_tabs: [
              {
                label: "Explanation",
                name: "Explanation",
                x_position: 17,
                y_position: 120,
                document_id: 1,
                width: 620,
                height: 300,
                optional: "false"
              }
            ]
          }
        ]
      )

      envelope
    end
  end
end
