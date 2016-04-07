# send email to Billy to notify that user wants to sign up.
module SlackBotServices
  class NotifySignUp
    extend ParseData

    def self.call(params)
      if data = parsed_data(params)
        MortgageBotMailer.inform_sign_up_information(data).deliver_later
      end
    end
  end
end
