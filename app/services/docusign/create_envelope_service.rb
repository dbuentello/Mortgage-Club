require "pdf_forms"

module Docusign
  class CreateEnvelopeService
    UNIFORM_PATH = "#{Rails.root}/form_templates/Interactive 1003 Form.unlocked.pdf".freeze
    FORM_4506_PATH = "#{Rails.root}/form_templates/form4506t.pdf".freeze
    BORROWER_CERTIFICATION_PATH = "#{Rails.root}/form_templates/Borrower-Certification-and-Authorization.pdf".freeze

    UNIFORM_OUTPUT_PATH = "#{Rails.root}/tmp/uniform.pdf".freeze
    FORM_4506_OUTPUT_PATH = "#{Rails.root}/tmp/form4506t.pdf".freeze
    BORROWER_CERTIFICATION_OUTPUT_PATH = "#{Rails.root}/tmp/certification.pdf".freeze

    attr_accessor :pdftk

    def initialize
      @pdftk = PdfForms.new(ENV.fetch("PDFTK_BIN", "/usr/local/bin/pdftk"), flatten: true)
    end

    def call(user, loan)
      create_document_by_adobe_field_names(loan)
      client = DocusignRest::Client.new
      envelope = client.create_envelope_from_document(
        status: "sent",
        email: {
          subject: "Electronic Signature Request from MortgageClub Corporation",
          body: "As discussed, let's finish our contract by signing to this envelope. Thank you!"
        },
        files: [
          {path: UNIFORM_OUTPUT_PATH},
          {path: FORM_4506_OUTPUT_PATH},
          {path: BORROWER_CERTIFICATION_OUTPUT_PATH}
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
                page_number: "4",
                x_position: "90",
                y_position: "439",
                document_id: "1",
                optional: "false"
              }
            ],
            date_signed_tabs: [
              {
                name: "Date Signed",
                page_number: "4",
                x_position: "521",
                y_position: "466",
                document_id: "1",
                fontSize: "size9",
                fontColor: "black",
                bold: "false",
                italic: "false",
                underline: "false"
              }
            ]
          }
        ]
      )
      File.delete(UNIFORM_OUTPUT_PATH)
      File.delete(FORM_4506_OUTPUT_PATH)
      File.delete(BORROWER_CERTIFICATION_OUTPUT_PATH)
      envelope
    end

    def create_document_by_adobe_field_names(loan)
      generate_uniform(loan)
      generate_form_4506
      generate_form_certification
    end

    def generate_uniform(loan)
      data = Docusign::Templates::UniformResidentialLoanApplication.new(loan).build
      pdftk.get_field_names(UNIFORM_PATH)
      pdftk.fill_form(UNIFORM_PATH, "tmp/uniform.pdf", data)
    end

    def generate_form_4506
      pdftk.get_field_names(FORM_4506_PATH)
      pdftk.fill_form(FORM_4506_PATH, "tmp/form4506t.pdf")
    end

    def generate_form_certification
      pdftk.get_field_names(BORROWER_CERTIFICATION_PATH)
      pdftk.fill_form(FORM_4506_PATH, "tmp/certification.pdf")
    end
  end
end
