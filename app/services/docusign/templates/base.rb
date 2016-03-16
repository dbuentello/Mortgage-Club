module Docusign
  module Templates
    class Base
      attr_accessor :template, :template_mapping, :docusign_base, :return_url, :user, :loan

      def initialize(loan, template, return_url, user)
        @loan = loan
        @template = template
        @template_mapping = template.template_mapping
        @return_url = return_url
        @user = user
        @docusign_base = Docusign::Base.new
      end

      def perform
        build_envelope
      end

      private

      def build_envelope
        envelope_response = docusign_base.create_envelope_from_template(envelope_hash)
        docusign_base.client.get_recipient_view(
          envelope_id: envelope_response["envelopeId"],
          name: user.to_s,
          email: user.email,
          return_url: return_url
        )
      end

      def envelope_hash
        {
          user: {name: user.to_s, email: user.email},
          values: mapping_value,
          embedded: true,
          loan_id: loan.id,
          template_name: template.name,
          template_id: template.docusign_id,
          email_subject: template.email_subject,
          email_body: template.email_body
        }
      end

      def mapping_value
        template_mapping.new(loan).params
      end
    end
  end
end
