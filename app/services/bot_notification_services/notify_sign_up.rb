# send email to Billy to notify that user wants to sign up.
module BotNotificationServices
  class NotifySignUp
    extend ParseData

    def self.call(params)
      output = {}
      if data = parsed_data(params)
        MortgageBotMailer.inform_sign_up_information(data, params[:source]).deliver_later
      end
      output[:data] = "Awesome, our team will reach out to you shortly with the next steps."
      output[:status_code] = 200
      output.to_json
    end
  end
end
