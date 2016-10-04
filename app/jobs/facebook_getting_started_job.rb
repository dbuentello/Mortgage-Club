class FacebookGettingStartedJob < ActiveJob::Base
  queue_as :default

  def perform
    BotServices::FacebookService.subscribe_request
    BotServices::FacebookService.config_welcome_screen
  end
end
