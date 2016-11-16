require 'sendgrid-ruby'

module SendGrid
  class SendEmail

    def initialize(current_user, params)
    end

    def call
      from = Email.new(email: 'billy@mortgageclub.co', name: "Billy Tran")
      subject = 'Hello World from the SendGrid Ruby Library!'
      to = Email.new(email: 'tang@mortgageclub.co')
      content = Content.new(type: 'text/plain', value: 'Hello, Email!')
      mail = Mail.new(from, subject, to, content)

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)

      ap response

      # mail_params = {
      #   from: params[:from],
      #   to: params[:to],
      #   bcc: params[:bcc],
      #   cc: params[:cc],
      #   subject: params[:subject]
      # }

      # @body = params[:body]

      # if params[:attachments].present?
      #   params[:attachments].each do |attachment|
      #     attachments[attachment.original_filename] = File.read(attachment.tempfile)
      #   end
      # end

      # mail(mail_params)
    end
  end
end
