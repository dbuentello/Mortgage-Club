# == Schema Information
#
# Table name: property_documents
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
    if description.blank?
      case type
      when 'AppraisalReport'
        self.description = 'Appraised property value'
      when 'HomeownersInsurance'
        self.description = "Homeowner's insurance"
      when 'MortgageStatement'
        self.description = "Latest mortgage statement of subject property"
      when 'LeaseAgreement'
        self.description = "Lease agreement"
      when 'PurchaseAgreement'
        self.description = "Executed purchase agreement"
      when 'FloodZoneCertification'
        self.description = "Flood zone certification"
      when 'TermiteReport'
        self.description = "Termite report"
      when 'InspectionReport'
        self.description = "Home inspection report"
      when 'TitleReport'
        self.description = "Preliminary title report"
      when 'RiskReport'
        self.description = "Home seller's disclosure report"
      end
    end
  end
end
