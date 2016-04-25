class SlackWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:receive]
  before_action :validate_slack_bot, only: [:receive]
  SLACK_BOT_HEADER_VALUE = "MCsLACK!".freeze

  def receive
    params[:source] = "Slack Bot"
    output = SlackBotServices::Base.new(params).call

    render json: {
      speech: output,
      displayText: output,
      source: "MortgageClub"
    }
  end

  private

  def validate_slack_bot
    return head :unauthorized if request.headers["HTTP_MORTGAGECLUB_SLACK"] != SLACK_BOT_HEADER_VALUE
  end
end
