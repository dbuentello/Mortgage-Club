class SendgridWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:receive]
  before_action :validate_sendgrid, only: [:receive]

  SENDGRID_HEADER_VALUE = "MCsLACK!".freeze

  def receive
    ap params
    ap params["sendgrid_webhook"]
    ap params["sendgrid_webhook"]["_json"]

    render nothing: true, status: 200
  end

  private

  def validate_sendgrid
    return head :unauthorized if params[:code] != SENDGRID_HEADER_VALUE
  end
end
