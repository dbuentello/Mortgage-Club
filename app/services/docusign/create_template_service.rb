module Docusign
  class CreateTemplateService
    def self.call(template_name, options = {})
      templates = DocusignRest::Client.new.get_templates
      docusign_template = templates["envelopeTemplates"].find { |t| t["name"] == template_name }

      return unless docusign_template

      options[:state] ||= "California"
      options[:description] ||= "sample template"
      options[:email_subject] ||= "Electronic Signature Request from Mortgage Club"
      options[:email_body] ||= "As discussed, let's finish our contract by signing to this envelope. Thank you!"
      options[:user_id] =  nil

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
  end
end
