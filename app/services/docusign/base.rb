require 'open-uri'

module Docusign
  class Base
    def initialize(args = nil)
      @client = DocusignRest::Client.new
    end

    # POST /accounts/#{acct_id}/envelopes
    # PARAMS:
    # => template_id / template_name
    # => signers
    # => email_subject, email_body
    # => user object
    # => values hash contain auto filled info
    # Docusign::Base.new.create_envelope_from_template(template_name: "Loan Estimation", email_subject: "New test 01/07/2015", user: {name: "Hoang", email: "le_hoang0306@yahoo.com.vn"}, values: { text: "$50000000" })
    def create_envelope_from_template(options = {})
      if options[:template_id].blank? && options[:template_name].blank?
        puts "Error: don't have enough params"
        return
      end

      helper = Docusign::Helper.new
      if options[:template_id].blank?
        options[:template_id] = helper.find_template_id_from_name(options[:template_name])
      end

      options[:email_subject] ||= "The test email subject envelope"
      options[:email_body] ||= "Envelope body content here"

      # Set values to tab labels
      # NOTE: need to map 2 names carefully (for example "Text" will take value from :text)
      values = {
        "Text" => options[:values][:text]
      }

      # Map data from databse to signers
      tabs = helper.get_tabs_from_template(template_id: options[:template_id], values: values)

      signers = []
      signer = {
        name: options[:user][:name],
        email: options[:user][:email],
        role_name: 'Normal'
      }
      signer = signer.merge(tabs)
      signers << signer
      ap signers

      # Get the corresponding document to send over with the achieved signers
      if options[:document]
        # options[:document] ||= Documents::FirstW2.first
        file_url = options[:document].attachment.s3_object.url_for(:read, :secure => true, :expires => 3.minutes).to_s
        file_io = open(file_url)
      else
        file_url = "/Users/hoangle/projects/homieo/public/examples/Loan Estimation.pdf"
      end

      envelope_response = @client.create_envelope_from_document(
        status: 'sent',
        email: {
          subject: options[:email_subject],
          body: options[:email_body]
        },
        template_id: options[:template_id],
        signers: signers,
        files: [
          { path: file_url, name: 'Loan Estimation.pdf' }
          # { io: file_io, name: options[:document].attachment.instance.attachment_file_name }
        ],
      )
    end

    def create_template_from_document(options = {})
      # TODO: method create_template_from_document
      # => generate draft template with name, default recipient
      # => we have to modify tab later before using create_envelope_from_template method
    end

  end
end