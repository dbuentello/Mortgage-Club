# require 'sendgrid-ruby'
# require 'base64'
# require 'securerandom'

module SendGrid
  class LoanTest
    # def self.call(current_user, params)
    #   uuid = SecureRandom.uuid
    #   loan = Loan.find(params[:loan_id])

    #   mail = Mail.new

    #   mail.subject = params[:subject]
    #   mail.from = Email.new(email: current_user.email, name: current_user.to_s)
    #   mail.contents = Content.new(type: 'text/html', value: params[:body])

    #   personalization = Personalization.new
    #   if params[:to].present?
    #     emails_to = params[:to].split(",")

    #     emails_to.each do |email_to|
    #       personalization.to = Email.new(email: email_to.strip)
    #     end
    #   else
    #     mail.to = Email.new(email: loan.borrower.user.email)
    #   end

    #   if params[:bcc].present?
    #     emails_bcc = params[:bcc].split(",")

    #     emails_bcc.each do |email_bcc|
    #       personalization.bcc = Email.new(email: email_bcc.strip)
    #     end
    #   end

    #   if params[:cc].present?
    #     emails_cc = params[:cc].split(",")

    #     emails_cc.each do |email_cc|
    #       personalization.cc = Email.new(email: email_cc.strip)
    #     end
    #   end

    #   personalization.custom_args = CustomArg.new(key: "token", value: uuid)
    #   personalization.custom_args = CustomArg.new(key: "email_type", value: "loan_member_send")

    #   mail.personalizations = personalization

    #   if params[:attachments].present?
    #     params[:attachments].each do |attachment|
    #       attachment_email = Attachment.new
    #       attachment_email.content = new Buffer(Base64.encode64(File.read(attachment.tempfile)), 'base64')
    #       attachment_email.type = attachment.content_type
    #       attachment_email.filename = attachment.original_filename
    #       attachment_email.disposition = 'attachment'

    #       mail.attachments = attachment_email
    #     end
    #   end

    #   sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])

    #   response = sg.client.mail._('send').post(request_body: mail.to_json)

    #   ap JSON.load(response.body)

    #   if response.status_code == "202"
    #     params[:to].split(",").each do |email_to|
    #       Ahoy::Message.create(
    #         token: uuid,
    #         to: email_to.strip,
    #         user_id: current_user.id,
    #         user_type: "Loan Member",
    #         loan_id: loan.id,
    #         subject: params[:subject]
    #       )
    #     end
    #   end
    # end
  end
end
