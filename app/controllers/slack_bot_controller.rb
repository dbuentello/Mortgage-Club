class SlackBotController < ApplicationController
  layout "slack"
  skip_before_action :authenticate_user!
  before_action :set_mixpanel_token, only: [:index]

  def bot
  end

  def privacy
  end
end
