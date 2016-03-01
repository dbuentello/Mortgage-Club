require "pdf_forms"

module Docusign
  class XyzService
    UNIFORM_URL = "#{Rails.root}/1003rev.unlocked.pdf".freeze

    def call
      create_document_by_adobe_field_names
      recipient_view = ""
      client = DocusignRest::Client.new
      envelope = client.create_envelope_from_document(
        status: "sent",
        email: {
          subject: "Electronic Signature Request from MortgageClub Corporation",
          body: "As discussed, let's finish our contract by signing to this envelope. Thank you!"
        },
        files: [
          {path: "#{Rails.root}/tmp/myform.pdf"},
          {path: "#{Rails.root}/tmp/myform.pdf"}
        ],
        signers: [
          {
            embedded: true,
            name: "Cuong Vu",
            email: "cuongvu0103@gmail.com",
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

      envelope
    end

    def create_document_by_adobe_field_names
      pdftk = PdfForms.new(ENV.fetch("PDFTK_BIN", "/usr/local/bin/pdftk"), flatten: true)
      pdftk.get_field_names(UNIFORM_URL)
      pdftk.fill_form(UNIFORM_URL, "tmp/myform.pdf", data)
    end

    def data
      {
        "VA" => "Yes",
        "FHA" => "Yes",
        "Agency Case Number" => "234243",
        "Subject Property Address" => "123 Le Loi, HCMC"
      }
    end
  end
end
