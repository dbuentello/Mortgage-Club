# == Schema Information
#
# Table name: borrower_documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :uuid
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#  description             :string
#  owner_type              :string
#  borrower_id             :uuid
#

class BorrowerDocument < ActiveRecord::Base
  include Documentation

  DOCUMENT_LIST = %w(FirstW2 SecondW2 FirstPaystub SecondPaystub FirstBankStatement SecondBankStatement FirstFederalTaxReturn SecondFederalTaxReturn FirstPersonalTaxReturn SecondPersonalTaxReturn FirstBusinessTaxReturn SecondBusinessTaxReturn OtherBorrowerReport)

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
    :original_file_name,
    :attachment
  ]

  EXPIRE_VIEW_SECONDS = 3

  before_validation :set_private_token, :on => :create
  before_validation :set_description

  def downloadable?(user)
    return false if borrower.blank? || user.blank? || user.borrower.blank?

    user.borrower == borrower
  end

  def name
    attachment_file_name
  end

  def url
    Amazon::GetUrlService.call(attachment)
  end

  def subject_name
    'Borrower'
  end

  def subject_key_name
    'borrower_id'
  end

  def upload_path
    '/document_uploaders/borrowers/upload'
  end

  private

  def set_private_token
    self.token = Digest::MD5.hexdigest(Time.now.utc.to_s)
  end
end
