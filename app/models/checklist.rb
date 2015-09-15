class Checklist < ActiveRecord::Base
  belongs_to :loan
  belongs_to :user
  belongs_to :template

  validates :due_date, :name, :info, :document_description,
            :user_id, :checklist_type, :status, :document,
            :document_type, :loan_id, presence: true
  validate :document_type_must_belong_to_proper_document

  def document_info
    document = document_type.constantize.new
    {
      label: document.label_name,
      upload_path: document.upload_path,
      subject_key_name: document.subject_key_name,
      subject_name: document.subject_name
    }
  end

  private

  def document_type_must_belong_to_proper_document
    case document
    when "borrower"
      return if BorrowerDocument::DOCUMENT_LIST.include? document_type
    when "property"
      return if PropertyDocument::DOCUMENT_LIST.include? document_type
    when "loan"
      return if LoanDocument::DOCUMENT_LIST.include? document_type
    when "closing"
      return if ClosingDocument::DOCUMENT_LIST.inclue? document_type
    end
    errors.add(:document_type, "must belong to a proper document")
  end
end