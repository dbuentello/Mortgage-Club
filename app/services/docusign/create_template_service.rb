module Docusign
  class CreateTemplateService
    def self.call(template_name, options = {})
      templates = DocusignRest::Client.new.get_templates
      docusign_template = templates["envelopeTemplates"].find { |t| t["name"] == template_name }

      return unless docusign_template

      options[:state] ||= I18n.t("services.docusign.create_template_service.state")
      options[:description] ||= I18n.t("services.docusign.create_template_service.description")
      options[:email_subject] ||= I18n.t("services.docusign.create_template_service.email_subject")
      options[:email_body] ||= I18n.t("services.docusign.create_template_service.email_body")
      options[:user_id] =  nil

      template = Template.where(name: docusign_template["name"]).first_or_initialize

      template.attributes = {
        docusign_id: docusign_template["templateId"],
        state: options[:state],
        description: options[:description],
        email_subject: options[:email_subject],
        email_body: options[:email_body],
        creator_id: options[:user_id],
        document_order: options[:document_order]
      }
      template.save
      template
    end
  end
end
