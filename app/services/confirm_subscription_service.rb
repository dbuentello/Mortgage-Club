class ConfirmSubscriptionService
  def self.call(raw_post)
    response = HTTParty.get(raw_post["SubscribeURL"], verify: false)
  end
end