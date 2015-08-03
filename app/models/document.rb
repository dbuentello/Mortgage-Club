# == Schema Information
#
# Table name: documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :integer
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#

class Document < ActiveRecord::Base

  # see this for reference: https://en.wikipedia.org/wiki/Internet_media_type#List_of_common_media_types
  ALLOWED_MIME_TYPES = [
    'image/jpg',
    'image/jpeg',
    'image/pjpeg',
    'image/gif',
    'image/png',
    'image/x-png',
    'image/tiff',
    'image/x-tiff',
    'image/vnd.adobe.photoshop',
    'application/pdf',
    'application/octet-stream',
    'application/x-photoshop',
    'application/msword',
    'application/vnd.ms-office',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/excel',
    'application/vnd.ms-excel',
    'application/x-excel',
    'application/x-msexcel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/mspowerpoint',
    'application/powerpoint',
    'application/vnd.ms-powerpoint',
    'application/x-mspowerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/rtf',
    'application/x-rtf',
    'application/zip', # file --mime-type spec/files/sample.xlsx => spec/files/sample.xlsx: application/zip
    'text/richtext',
    'text/rtf',
    'text/plain',
    'inode/x-empty'
  ]

  belongs_to :borrower, foreign_key: 'owner_id'

  has_attached_file :attachment,
    s3_permissions: 'authenticated-read',
    path: ":class/:token/:filename"

  validates_presence_of :token

  validates_attachment :attachment,
    presence: true,
    content_type: {
      content_type: Document::ALLOWED_MIME_TYPES,
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
    return false if borrower.blank? || user.blank? || user.borrower.blank?

    user.borrower == borrower
  end

  def name
    attachment_file_name
  end

  def url
    attachment.url
  end

  private

  def set_private_token
    self.token = Digest::MD5.hexdigest(Time.now.to_s)
  end

end
