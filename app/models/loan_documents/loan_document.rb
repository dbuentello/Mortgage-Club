# == Schema Information
#
# Table name: loan_documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :integer
#  description             :string
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#

class LoanDocument < ActiveRecord::Base

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
  before_validation :set_description

  def downloadable?(user)
    # return false if borrower.blank? || user.blank? || user.borrower.blank?

    # user.borrower == borrower
  end

  private

  def set_private_token
    self.token = Digest::MD5.hexdigest(Time.now.to_s)
  end

  def set_description
    byebug
    if description.blank?
      case type
      when 'HudEstimate'
        self.description = "Estimated settlement statement"
      when 'HudFinal'
        self.description = "Final settlement statement"
      when 'LoanEstimate'
        self.description = "Loan estimate"
      when 'UniformResidentialLendingApplication'
        self.description = "Loan application form"
      end
    end
  end
end
