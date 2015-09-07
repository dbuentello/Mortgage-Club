# == Schema Information
#
# Table name: loan_documents
#
#  id                      :uuid             not null, primary key
#  type                    :string
#  owner_id                :uuid
#  description             :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#  loan_id                 :uuid
#  owner_type              :string
#

class LoanDocument < ActiveRecord::Base
  include Documentation

  has_attached_file :attachment,
    s3_permissions: 'authenticated-read',
    path: PAPERCLIP[:default_path]

  belongs_to :owner, polymorphic: true

  validates :owner, :token, presence: true

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
  before_validation :set_description

  def subject_name
    'Loan'
  end

  def subject_key_name
    'loan_id'
  end

  def upload_path
    '/document_uploaders/loans/upload'
  end

  private

  def set_private_token
    self.token = Digest::MD5.hexdigest(Time.now.utc.to_s)
  end
end
