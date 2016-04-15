# send email to Billy to notify that user wants to sign up.
module SlackBotServices
  class NotifySignUp
    extend ParseData

    def self.call(params)
      if data = parsed_data(params)
        MortgageBotMailer.inform_sign_up_information(data).deliver_later
      end
      "Awesome, our team will reach out to you shortly with the next steps."
    end
  end
end
