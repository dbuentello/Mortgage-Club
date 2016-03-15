class PotentialRateDropUser < ActiveRecord::Base
  PERMITTED_ATTRS = [
    :email,
    :phone_number,
    :refinance_purpose,
    :current_mortgage_balance,
    :current_mortgage_rate,
    :estimated_home_value,
    :zip,
    :credit_score,
    :send_as_email,
    :send_as_text_message
  ]

  validates :email, presence: true
  validates :refinance_purpose, presence: true
  validates :current_mortgage_balance, presence: true
  validates :current_mortgage_rate, presence: true
  validates :credit_score, presence: true
  validates :estimated_home_value, presence: true
  validates :zip, presence: true

  def alert_method
    return "Email and Text Message" if send_as_email && send_as_text_message
    return "Email" if send_as_email
    "Text Message"
  end

  private

  def alert_method_cannot_be_blank
    errors.add(:alert_method, "can't be blank") if (send_as_email.nil? && send_as_text_message.nil?) || (!send_as_email && !send_as_text_message)
  end
end
