require 'nexmo'

class NexmoService
  def self.send_sms
    @client = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'] , secret: ENV['NEXMO_API_SECRET'])

    from = '+19853020418'

    # to = '+84906944722'
    to = '+16507877799'

    puts "Send from #{from} to #{to}"

    @client.send_message(
      from: from,
      to: to,
      text: "Hey there! I'm Hoang from Nexmo."
    )
  end
end