class PropertyDocument < ActiveRecord::Base

  has_attached_file :attachment,
    s3_permissions: 'authenticated-read',
    path: ":class/:token/:filename"

  validates_presence_of :token

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
    :attachment
  ]

  EXPIRE_VIEW_SECONDS = 3

  before_validation :set_private_token, :on => :create

  def downloadable?(user)
    # return false if borrower.blank? || user.blank? || user.borrower.blank?

    # user.borrower == borrower
  end

  private

  def set_private_token
    self.token = Digest::MD5.hexdigest(Time.now.to_s)
  end
end