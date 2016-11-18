require 'securerandom'

class LoanMemberDashboardMailer < ActionMailer::Base
  include SendGrid

  def remind_checklists(current_user, params)
    uuid = SecureRandom.uuid
    sendgrid_unique_args email_type: "loan_member_send", token: uuid

    mail_params = {
      from: params[:from],
      to: params[:to],
      bcc: params[:bcc],
      cc: params[:cc],
      subject: params[:subject]
    }

    @body = params[:body]

    if params[:attachments].present?
      params[:attachments].each do |attachment|
        attachments[attachment.original_filename] = File.read(attachment.tempfile)
      end
    end

    mail(mail_params)

    params[:to].split(",").each do |email_to|
      Message.create(
        to: email_to,
        token: uuid,
        subject: params[:subject],
        content: params[:body],
        user_id: current_user.id,
        loan_id: params[:loan_id]
      )
    end
  end
end
