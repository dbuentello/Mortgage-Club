require "pdf_forms"

module Docusign
  #
  # Class CreateEnvelopeService provides creating an envelope and send it to Docusign.
  # envelope is a Docusign's term. One envelope is a document which was signed.
  #
  #
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
      generates_documents_by_adobe_field_names(loan)
      envelope = generate_envelope(user, loan)
      delete_temp_files

      envelope
    end

    #
    # Map value to Adobe's PDFs
    #
    # @param [Loan] loan
    #
    #
    def generates_documents_by_adobe_field_names(loan)
      generate_uniform(loan)
      generate_form_4506
      generate_form_certification
    end

    #
    # Make a request to Docusign
    #
    # @param [User] user a borrower
    # @param [Loan] loan a loan
    # signers who sign envelope
    #
    # @return [Object] a Docusign's response
    #
    def generate_envelope(user, loan)
      DocusignRest::Client.new.create_envelope_from_document(
        status: "sent",
        email: {
          subject: I18n.t("services.docusign.create_envelope_service.envelope_email_subject"),
          body: I18n.t("services.docusign.create_envelope_service.evelope_email_body")
        },
        files: [
          {path: UNIFORM_OUTPUT_PATH},
          {path: FORM_4506_OUTPUT_PATH},
          {path: BORROWER_CERTIFICATION_OUTPUT_PATH}
        ],
        signers: build_signers(user, loan)
      )
    end

    def delete_temp_files
      File.delete(UNIFORM_OUTPUT_PATH)
      File.delete(FORM_4506_OUTPUT_PATH)
      File.delete(BORROWER_CERTIFICATION_OUTPUT_PATH)
    end

    private

    #
    # Get uniform's data and map to PDF file.
    #
    def generate_uniform(loan)
      data = Docusign::Templates::UniformResidentialLoanApplication.new(loan).build
      pdftk.get_field_names(UNIFORM_PATH)
      pdftk.fill_form(UNIFORM_PATH, "tmp/uniform.pdf", data)
    end

    #
    # Get form 4506's data and map to PDF file.
    #
    def generate_form_4506
      pdftk.get_field_names(FORM_4506_PATH)
      pdftk.fill_form(FORM_4506_PATH, "tmp/form4506t.pdf")
    end

    #
    # Get form certification's data and map to PDF file.
    #
    def generate_form_certification
      pdftk.get_field_names(BORROWER_CERTIFICATION_PATH)
      pdftk.fill_form(BORROWER_CERTIFICATION_PATH, "tmp/certification.pdf")
    end

    #
    # Build a hash which contains signers
    #
    # @param [User] user
    # @param [Loan] loan
    #
    # @return [Hash] return signers which contains signers' info.
    # signers is person who sign envelope.
    # envelope is a Docusign's term. One envelope is a document which was signed.
    #
    def build_signers(user, loan)
      signers =
        [
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
                x_position: "240",
                y_position: "467",
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

      if loan.secondary_borrower
        signers << {
          embedded: true,
          name: "#{loan.secondary_borrower.user.first_name} #{loan.secondary_borrower.user.last_name}",
          email: loan.secondary_borrower.user.email,
          role_name: "Normal",
          sign_here_tabs: [
            {
              name: "Signature",
              page_number: "4",
              x_position: "385",
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
              y_position: "467",
              document_id: "1",
              fontSize: "size9",
              fontColor: "black",
              bold: "false",
              italic: "false",
              underline: "false"
            }
          ]
        }
      end

      signers
    end
  end
end
