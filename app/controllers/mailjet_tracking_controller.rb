class MailjetTrackingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :track
  skip_before_action :authenticate_user!

  def track
    if valid?
      Loan.find_by_id(@loan_id)
      # loan.read! if loan
    end
    render nothing: true, status: 200, content_type: 'text/html'
  end

  private

  def valid?
    return false unless params["event"].present? && params["event"] == "open"
    return false unless params["CustomID"].present?

    parse_custom_id
    return false if @email_type != "Lock Loan" || @loan_id.blank?
    true
  end

  def parse_custom_id
    custom_id = params["CustomID"].split(" - ")
    @email_type = custom_id.first
    @loan_id = custom_id.last
  end
end
