class LoanMemberDashboardMailer < ActionMailer::Base
  def remind_checklists(params)
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
  end
end
