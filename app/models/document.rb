class Document < ActiveRecord::Base
  include Documentation

  BORROWER_LIST = %w(first_w2 second_w2 first_paystub second_paystub first_bank_statement second_bank_statement
                    first_federal_tax_return second_federal_tax_return first_personal_tax_return second_personal_tax_return
                    first_business_tax_return second_business_tax_return other_borrower_report)

  CLOSING_LIST  = %w(closing_disclosure deed_of_trust loan_doc other_closing_report)

      LOAN_LIST = %w(hud_estimate hud_final loan_estimate uniform_residential_lending_application other_loan_report)

  PROPERTY_LIST = %w(appraisal_report flood_zone_certification homeowners_insurance
                    inspection_report lease_agreement mortgage_statement purchase_agreement
                    risk_report termite_report title_report other_property_report)

  has_attached_file :attachment,
    s3_permissions: 'authenticated-read',
    path: PAPERCLIP[:default_path]

  belongs_to :subjectable, polymorphic: true
  belongs_to :user
  validates :user_id, :subjectable_type, :subjectable_id, :token, :description, :document_type, presence: true

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

  validate :document_type_must_belong_to_proper_document

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

  def document_type_must_belong_to_proper_document
    case subjectable_type
    when "Borrower"
      return if BORROWER_LIST.include? document_type
    when "Property"
      return if PROPERTY_LIST.include? document_type
    when "Loan"
      return if LOAN_LIST.include? document_type
    when "Closing"
      return if CLOSING_LIST.include? document_type
    end
    errors.add(:document_type, "must belong to a proper document")
  end
end
