require "pdf_forms"
require 'open-uri'
# Module Docusign provides methods to generate uniform
# @author Tang Nguyen <tang@mortgageclub.co>
module Docusign
  # Class CreateEnvelopeService provides creating an envelope and send it to Docusign.
  # envelope is a Docusign's term. One envelope is a document which was signed.
  class CreateEnvelopeService
    UNIFORM_PATH = "#{Rails.root}/form_templates/Interactive 1003 Form.unlocked.pdf".freeze
    LIABILITIES_PATH = "#{Rails.root}/form_templates/liabilities.pdf".freeze
    REAL_ESTATE_PATH = "#{Rails.root}/form_templates/real_estate.pdf".freeze

    UNIFORM_OUTPUT_PATH = "#{Rails.root}/tmp/uniform.pdf".freeze
    LIABILITIES_OUTPUT_PATH = "#{Rails.root}/tmp/liabilities.pdf".freeze
    REAL_ESTATE_OUTPUT_PATH = "#{Rails.root}/tmp/real_estate.pdf".freeze

    attr_accessor :pdftk, :extra_docusign_forms, :extra_real_estate_form, :extra_liabilities_form

    def initialize
      @pdftk = PdfForms.new(ENV.fetch("PDFTK_BIN", "/usr/local/bin/pdftk"), flatten: true)
      @extra_docusign_forms = nil
      @extra_real_estate_form = false
      @extra_liabilities_form = false
    end

    def call(user, loan)
      @extra_docusign_forms = LenderDocusignForm.where(lender_id: loan.lender_id).order(doc_order: :asc)
      generates_documents_by_adobe_field_names(loan)
      envelope = generate_envelope(user, loan)
      delete_temp_files
      envelope
    end

    # Map value to Adobe's PDFs
    # @param [Loan] loan
    def generates_documents_by_adobe_field_names(loan)
      generate_uniform(loan)
      generate_extra_form(loan)
    end

    # Make a request to Docusign
    # @param [User] user a borrower
    # @param [Loan] loan a loan
    # signers who sign envelope
    # @return [Object] a Docusign's response
    def generate_envelope(user, loan)
      DocusignRest::Client.new.create_envelope_from_document(
        status: "sent",
        email: {
          subject: I18n.t("services.docusign.create_envelope_service.envelope_email_subject"),
          body: I18n.t("services.docusign.create_envelope_service.evelope_email_body")
        },
        files: output_files,
        signers: build_signers(user, loan)
      )
    end

    def output_files
      output_files = [
        {path: UNIFORM_OUTPUT_PATH}
      ]
      output_files << {path: LIABILITIES_OUTPUT_PATH} if @extra_liabilities_form
      output_files << {path: REAL_ESTATE_OUTPUT_PATH} if @extra_real_estate_form
      @extra_docusign_forms.each do |f|
        output_files << {path: "#{Rails.root}/tmp/#{f.attachment_file_name}".freeze}
      end
      output_files
    end

    def delete_temp_files
      File.delete(UNIFORM_OUTPUT_PATH)
      File.delete(LIABILITIES_OUTPUT_PATH) if @extra_liabilities_form
      File.delete(REAL_ESTATE_OUTPUT_PATH) if @extra_real_estate_form
      @extra_docusign_forms.each do |f|
        File.delete("#{Rails.root}/tmp/#{f.attachment_file_name}")
      end
    end

    private

    # Get uniform's data and map to PDF file.
    def generate_uniform(loan)
      data = Docusign::Templates::UniformResidentialLoanApplication.new(loan).build
      fill_form_data(UNIFORM_PATH, "tmp/uniform.pdf", data)
      today_date = Time.zone.now.to_date
      if data[:liabilities_company_7].present? || data["asset_5"].present?
        @extra_liabilities_form = true
        data["date_signed_liabilities.1"] = today_date
        data["date_signed_liabilities.2"] = today_date
        fill_form_data(LIABILITIES_PATH, "tmp/liabilities.pdf", data)
      end
      if data["rental_property_address_4"].present?
        @extra_real_estate_form = true
        data["date_signed_real_estate.1"] = today_date
        data["date_signed_real_estate.2"] = today_date
        fill_form_data(REAL_ESTATE_PATH, "tmp/real_estate.pdf", data)
      end
    end

    def generate_extra_form(loan)
      @extra_docusign_forms.each do |f|
        file_data = open(f.attachment.url)
        @field_names = pdftk.get_field_names(file_data)
        data = Docusign::Templates::ExtraForm.new(loan, @field_names).build
        pdftk.fill_form(file_data, "#{Rails.root}/tmp/#{f.attachment_file_name}", data)
      end
    end

    def fill_form_data(path, output_path, data)
      pdftk.get_field_names(path)
      pdftk.fill_form(path, output_path, data) 
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
            sign_here_tabs: build_ex_borrower_sign,
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
          sign_here_tabs: build_ex_co_borrower_sign,
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

    def build_ex_borrower_sign
      signs = [
        {
          name: "Signature",
          page_number: "1",
          x_position: "60",
          y_position: "75",
          document_id: "1",
          optional: "false"
        },
        {
          name: "Signature",
          page_number: "4",
          x_position: "90",
          y_position: "439",
          document_id: "1",
          optional: "false"
        }
      ]
      @extra_docusign_forms.each do |f|
        ex_signs = JSON.parse(f.sign_position, symbolize_names: true)
        ex_signs.each do |s|
          signs << s
        end
      end
      signs
    end

    def build_ex_co_borrower_sign
      signs = [
        {
          name: "Signature",
          page_number: "1",
          x_position: "255",
          y_position: "75",
          document_id: "1",
          optional: "false"
        },
        {
          name: "Signature",
          page_number: "4",
          x_position: "385",
          y_position: "439",
          document_id: "1",
          optional: "false"
        }
      ]
      @extra_docusign_forms.each do |f|
        ex_signs = JSON.parse(f.co_borrower_sign, symbolize_names: true)
        ex_signs.each do |s|
          signs << s
        end
      end
      signs
    end
  end
end
