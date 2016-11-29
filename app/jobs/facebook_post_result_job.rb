class FacebookPostResultJob < ActiveJob::Base
  queue_as :default

  def perform(sender_id, params, intent)
    if intent.index("dti calculator").present?
      BotServices::CalculateDtiRatio.new(sender_id, params).call
    elsif intent.index("house affordability").present?

    else
      BotServices::GetDataOfQuotes.call(sender_id, params)
    end
  end
end
