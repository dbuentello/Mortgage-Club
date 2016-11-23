class FacebookPostResultJob < ActiveJob::Base
  queue_as :default

  def perform(sender_id, params)
    BotServices::GetDataOfQuote.call(sender_id, params)
  end
end
