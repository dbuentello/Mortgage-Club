# == Schema Information
#
# Table name: potential_users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  name                   :string
#  phone_number           :string
#  mortgage_statement     :attachment       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
class PotentialUser < ActiveRecord::Base

  PERMITTED_ATTRS = [
    :email,
    :phone_number,
    :mortgage_statement,
    :send_as_email,
    :send_as_text_message
  ]

  has_attached_file :mortgage_statement, path: PAPERCLIP[:potential_user_document_path]

  validates :email, presence: true
  validates_attachment :mortgage_statement,
    presence: true,
    content_type: {
      content_type: ALLOWED_MIME_TYPES,
      message: ' allows MS Excel, MS Documents, MS Powerpoint, Rich Text, Text File and Images'
    },
    size: {
      less_than_or_equal_to: 10.megabytes,
      message: ' must be less than or equal to 10MB'
    }
  validate :alert_method_cannot_be_blank

  def url
    Amazon::GetUrlService.call(mortgage_statement, 900)
  end

  def alert_method
    return "Email and Text Message" if send_as_email && send_as_text_message
    return "Email" if send_as_email
    "Text Message"
  end

  private

  def alert_method_cannot_be_blank
    errors.add(:alert_method, "can't be blank") if send_as_email.nil? && send_as_text_message.nil?
  end
end
