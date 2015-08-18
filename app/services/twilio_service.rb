require 'twilio-ruby'

class TwilioService
  def self.send_sms
    @client = Twilio::REST::Client.new

    from = '+14695072663'

    # to = '+84906944722'
    to = '+16507877799'

    puts "Send from #{from} to #{to}"

    sms = @client.messages.create(
      from: from,
      to: to,
      body: "Hey there! I'm Hoang from Twilio."
    )
  end

end
