require 'open-uri'

module Docusign
  class Demo
    def initialize(args = nil)
      @client = DocusignRest::Client.new
    end

    # POST /accounts/#{acct_id}/envelopes
    # PARAMS:
    # => template_id / template_name
    # => signers
    # => email_subject, email_body
    def create_envelope_from_template(options = {})
      if options[:template_id].blank? && options[:template_name].blank?
        puts "Error: don't have enough params"
        return
      end

      if options[:template_id].blank?
        options[:template_id] = find_template_id_from_name(options[:template_name])
      end

      options[:email_subject] ||= "The test email subject envelope"
      options[:email_body] ||= "Envelope body content here"

      if options[:signers].blank?
        # just for test
        options[:signers] = [
          {
            name: 'Nghia',
            email: 'le_hoang0306@yahoo.com.vn',
            role_name: 'Normal',
            text_tabs: [
              {
                label: 'Signature 1',
                name: 'Name template ne',
                value: 'Tui chu ai'
              }
            ],
            sign_here_tabs: [
              {
                name: "Name day ne",
                label: 'Signature 1',
                value: 'Khong dung hang',
                optional: false
              }
            ]
          }
        ]
      end

      envelope_response = @client.create_envelope_from_template(
        status: 'sent',
        email: {
          subject: options[:email_subject],
          body: options[:email_body]
        },
        template_id: options[:template_id],
        signers: options[:signers]
      )
    end

    def create_template_from_document(options = {})
      # TODO: method create_template_from_document
      # => generate draft template with name, default recipient
      # => we have to modify tab later before using create_envelope_from_template method
    end




    #===================================================================
    # For testing
    # POST multiple /accounts/#{acct_id}/envelopes
    def create_envelope_from_document(options = {})
      # options[:document] ||= Documents::FirstW2.first
      # file_url = options[:document].attachment.s3_object.url_for(:read, :secure => true, :expires => 3.minutes).to_s

      file_url = "/Users/hoangle/projects/homieo/public/examples/sample.pdf"
      file_io = open(file_url)

      user = {
        email: 'henryle0306@gmail.com',
        name: 'Henry'
      }

      # user = {
      #   email: 'billy@mortgageclub.io',
      #   name: 'Billy'
      # }

      document_envelope_response = @client.create_envelope_from_document(
        email: {
          subject: "Test Envelope from document",
          body: "let sign it guys"
        },
        # If embedded is set to true  in the signers array below, emails
        # don't go out to the signers and you can embed the signature page in an
        # iFrame by using the @client.get_recipient_view method
        signers: [
          {
            embedded: false,
            name: user[:name],
            email: user[:email],
            role_name: 'Issuer',
            sign_here_tabs: [
              {
                label: 'Signature 1',
                optional: false,
                document_id: 1,
                page_number: 1,
                x_position: '100',
                y_position: '80'
              }
            ],
            text_tabs: [
              {
                name: 'Property Sale Price', # tittle
                label: 'Property Sale Price',
                value: '$20.000',
                required: true,
                locked: false,
                document_id: 1,
                page_number: 1,
                x_position: '100',
                y_position: '160'
              },
              {
                name: 'Loan Amount',
                required: true,
                anchor_string: 'Loan Amount',
                anchor_x_offset: '185',
                anchor_y_offset: '0',
                anchor_ignore_if_not_present: false
              }
            ]
          }
        ],
        files: [
          {path: file_url, name: 'sample.pdf'}
          # {io: file_io, name: options[:document].attachment.instance.attachment_file_name}
        ],
        status: 'sent'
      )
    end

    # For testing
    # POST /accounts/#{acct_id}/envelopes
    def add_recipients_to_envelope(envelope_id, signers, resend_envelope = false)
      signers ||= [
        {
          recipient_id: 3,
          name: 'Nghia',
          email: 'le_hoang0306@yahoo.com.vn',
          role_name: 'Normal',
          sign_here_tabs: [
            {
              name: "Name day ne",
              label: 'Signature 1',
              value: 'Khong dung hang',
              document_id: 1,
              page_number: 1,
              x_position: '100',
              y_position: '80',
              optional: false
            }
          ]
        }
      ]

      envelope_response = @client.add_recipients(
        envelope_id: envelope_id,
        signers: signers,
        resend_envelope: resend_envelope
      )
    end
  end
end