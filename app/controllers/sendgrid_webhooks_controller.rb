class SendgridWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:receive]
  before_action :validate_sendgrid, only: [:receive]

  SENDGRID_HEADER_VALUE = "MCsLACK!".freeze

  def receive
    if params["sendgrid_webhook"].present? && params["sendgrid_webhook"]["_json"].present?
      params["sendgrid_webhook"]["_json"].each do |webhook|
        case webhook["send_type"]
        when "loan_member_send"
          process_loan_member_send(webhook)
        end
      end
    end

    ap params["sendgrid_webhook"]
    render nothing: true, status: 200
  end

  private

  def process_loan_member_send(webhook)
    message = Message.find_by(to: webhook["email"], token: webhook["token"])
    if message
      message.opened_at = Time.zone.now if webhook["event"] == "open"

      message.clicked_at = Time.zone.now if webhook["event"] == "click"

      message.save
    end
  end

  def validate_sendgrid
    return head :unauthorized if params[:code] != SENDGRID_HEADER_VALUE
  end
end
