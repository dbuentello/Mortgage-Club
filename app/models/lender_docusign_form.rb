class LenderDocusignForm < ActiveRecord::Base
  belongs_to :lender
  has_attached_file :attachment, path: PAPERCLIP[:default_upload_path], s3_server_side_encryption: 'AES256'

  PERMITTED_ATTRS = [
    :description,
    :sign_position,
    :lender_id,
    :attachment,
    :doc_order,
    :co_borrower_sign,
    :spouse_signed
  ]
  validates :lender_id, presence: true
  validates_attachment :attachment,
    presence: true,
    content_type: {
      content_type: 'application/pdf'
    },
    size: {
      less_than_or_equal_to: 10.megabytes,
      message: :size_too_large
    }
end
