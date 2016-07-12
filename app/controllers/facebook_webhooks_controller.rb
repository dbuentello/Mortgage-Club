class FacebookWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:receive, :save_data, :refinance]
  before_action :validate_slack_bot, only: [:receive, :save_data, :refinance]
  FB_BOT_HEADER_VALUE = "MCfB!".freeze # token verify - Nodejs server needs to send if wanna access

  def receive
    output = FacebookBotServices::GetInfoOfQuotes.call(params)

    render json: {
      speech: output,
      displayText: output,
      source: "MortgageClub"
    }
  end

  def refinance
    output = RefinanceProposalServices::Base.new(params).call

    render json: {
      speech: output,
      displayText: output,
      source: "MortgageClub"
    }
  end

  def save_data
    FacebookBotServices::SaveData.call(params)
    render nothing: true, status: 200
  end

  private

  def validate_slack_bot
    return head :unauthorized if request.headers["HTTP_MORTGAGECLUB_FB"] != FB_BOT_HEADER_VALUE
  end
end
