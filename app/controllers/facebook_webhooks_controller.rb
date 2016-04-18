class FacebookWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:receive]

  def receive
    output = FacebookBotServices::GetInfoOfQuotes.call(params)
    render json: { output: output }
  end
end
