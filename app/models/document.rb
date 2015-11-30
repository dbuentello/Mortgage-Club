class Document < ActiveRecord::Base
  include Documentation

  # DOCUMENT_LIST = %w(FirstW2 SecondW2 FirstPaystub SecondPaystub FirstBankStatement SecondBankStatement FirstFederalTaxReturn SecondFederalTaxReturn FirstPersonalTaxReturn SecondPersonalTaxReturn FirstBusinessTaxReturn SecondBusinessTaxReturn OtherBorrowerReport)
  has_attached_file :attachment,
    s3_permissions: 'authenticated-read',
    path: PAPERCLIP[:default_path]

  belongs_to :subjectable, polymorphic: true
  belongs_to :user
  validates :subjectable_type, :subjectable_id, :token, :description, :document_type, presence: true

  validates_attachment :attachment,
    presence: true,
    content_type: {
      content_type: ALLOWED_MIME_TYPES,
      message: ' allows MS Excel, MS Documents, MS Powerpoint, Rich Text, Text File and Images'
    },
    size: {
      less_than_or_equal_to: 10.megabytes,
      message: ' must be less than or equal to 10MB'
    }

  PERMITTED_ATTRS = [
    :type,
    :original_file_name,
    :attachment
  ]

  EXPIRE_VIEW_SECONDS = 3

  before_validation :set_private_token, on: :create

  def url
    Amazon::GetUrlService.call(attachment)
  end

  def upload_path
    '/document_uploaders/upload'
  end

  private

  def set_private_token
    return if token.present?

    self.token = Digest::MD5.hexdigest(Time.now.utc.to_s)
  end
end
