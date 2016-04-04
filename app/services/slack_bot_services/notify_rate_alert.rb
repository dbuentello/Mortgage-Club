# send email to Billy to notify that user wants to sign up for rate alert.
module SlackBotServices
  class NotifyRateAlert
    extend ParseData

    def self.call(params)
      if data = parsed_data(params)
        MortgageBotMailer.inform_rate_information(data).deliver_later
      end
    end
  end
end
