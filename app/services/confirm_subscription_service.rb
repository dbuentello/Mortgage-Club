class ConfirmSubscriptionService
  def self.call(raw_post)
    HTTParty.get(raw_post["SubscribeURL"], verify: false)
  end
end