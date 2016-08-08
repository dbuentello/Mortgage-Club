class SlackBotController < ApplicationController
  layout "slack"
  skip_before_action :authenticate_user!

  def bot
  end

  def privacy
  end
end
