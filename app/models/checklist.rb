class Checklist < ActiveRecord::Base
  belongs_to :loan
  belongs_to :user
  belongs_to :template

  validates :due_date, :name, :info, :document_description,
            :user_id, :checklist_type, :status, :subject_name,
            :document_type, :loan_id, presence: true
  validate :document_type_must_belong_to_proper_document

  private

  def document_type_must_belong_to_proper_document
    case subject_name
    when "Borrower"
      return if Document::BORROWER_LIST.include? document_type
    when "Property"
      return if Document::PROPERTY_LIST.include? document_type
    when "Loan"
      return if Document::LOAN_LIST.include? document_type
    when "Closing"
      return if Document::CLOSING_LIST.inclue? document_type
    end
    errors.add(:document_type, "must belong to a proper document")
  end
end