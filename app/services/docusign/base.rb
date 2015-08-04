require 'open-uri'

module Docusign
  class Base
    def initialize(args = {})
      @client = DocusignRest::Client.new
      @helper = Docusign::Helper.new(client: @client)
    end

    def client
      @client
    end

    def helper
      @helper
    end

    # POST /accounts/#{acct_id}/envelopes
    # PARAMS:
    # => template_id / template_name
    # => signers
    # => email_subject, email_body
    # => user object
    # => values hash contain auto filled info
    # Docusign::Base.new.create_envelope_from_template(template_name: "Loan Estimation", email_subject: "New test 01/07/2015", user: {name: "Hoang", email: "le_hoang0306@yahoo.com.vn"}, values: { phone: "0906944722" })
    def create_envelope_from_template(options = {})
      if options[:template_id].blank? && options[:template_name].blank?
        puts "Error: don't have enough params"
        return
      end

      options = @helper.make_sure_template_name_and_id_exist(options)

      options[:embedded] ||= false
      options[:email_subject] ||= "The test email subject envelope"
      options[:email_body] ||= "Envelope body content here"

      # Map data from databse to signers
      tabs = @helper.get_tabs_from_template(
        template_id: options[:template_id], template_name: options[:template_name],
        values: options[:values]
      )

      signers = []
      signer = {
        embedded: options[:embedded],
        name: options[:user][:name],
        email: options[:user][:email],
        role_name: 'Normal'
      }
      signer = signer.merge(tabs)
      signers << signer

      # Get the corresponding document to send over with the achieved signers
      if options[:document]
        # options[:document] ||= Documents::FirstW2.first
        file_url = Amazon::GetUrlService.new(options[:document].attachment.s3_object, 3.minutes).call
        file_io = open(file_url)
        file = { io: file_io, name: options[:document].attachment.instance.attachment_file_name }
      else
        file_url = "#{Rails.root}/vendor/files/templates/#{options[:template_name]}.pdf"
        file = { path: file_url, name: "#{options[:template_name]}.pdf" }
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
          file
        ]
      )

      # create envelope in database for reference
      create_envelope_object_from_response(envelope_response["envelopeId"], options[:template_id], options[:loan_id])

      # return envelope response
      envelope_response
    end

    # Use this to store a template information
    # => Run this before using create_envelope_from_template
    def create_template_object_from_name(template_name, options = {})
      templates = @client.get_templates
      docusign_template = templates["envelopeTemplates"].find { |a| a["name"] == template_name }

      options[:state] = options[:state] || "California"
      options[:description] = options[:description] || "sample template"
      options[:email_subject] = options[:email_subject] || "Electronic Signature Request from Mortgage Club"
      options[:email_body] = options[:email_body] || "As discussed, let's finish our contract by signing to this envelope. Thank you!"
      options[:user_id] = options[:user_id] || nil

      template = Template.where(name: docusign_template["name"]).first_or_initialize
      template.attributes = {
        docusign_id: docusign_template["templateId"],
        state: options[:state],
        description: options[:description],
        email_subject: options[:email_subject],
        email_body: options[:email_body],
        creator_id: options[:user_id]
      }
      template.save

      template
    end

    private

    # mini method to store envelope data to our database
    def create_envelope_object_from_response(envelope_id, template_id, loan_id)
      envelope = Envelope.new(
        docusign_id: envelope_id,
        template_id: template_id,
        loan_id: loan_id
      )

      envelope.save
    end

  end
end