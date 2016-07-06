class FacebookBotController < ApplicationController
  layout "slack"
  skip_before_action :authenticate_user!

  # get view for facebook bot
  #
  # @return [view] view for bot
  def bot
  end

  def privacy
  end
end
