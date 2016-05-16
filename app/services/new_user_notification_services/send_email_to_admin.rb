# send email to Billy to notify that user wants to sign up.
module NewUserNotificationServices
  class SendEmailToAdmin
    def self.call(params)
      NewUserMailer.inform_sign_up_information(params).deliver_later
    end
  end
end
