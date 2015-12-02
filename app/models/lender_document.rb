class LenderDocument < ActiveRecord::Base
  EXPIRE_VIEW_SECONDS = 5
  has_attached_file :attachment,
    s3_permissions: 'authenticated-read',
    path: PAPERCLIP[:default_path]

  belongs_to :user
  validates :user_id, :loan_id, :token, :description, presence: true
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

  before_validation :set_private_token, on: :create

  private

  def set_private_token
    return if token.present?

    self.token = Digest::MD5.hexdigest(Time.now.utc.to_s)
  end
end