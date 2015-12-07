class Checklist < ActiveRecord::Base
  belongs_to :loan
  belongs_to :user
  belongs_to :template

  validates :due_date, :name, :info, :document_description,
            :user_id, :checklist_type, :status, :subject_name,
            :document_type, :loan_id, presence: true
  validate :document_type_must_belong_to_proper_document
  validate :subject_name_must_belong_to_proper_subject

  def subject_id
    loan = Loan.find(loan_id)
    case subject_name
    when "Property"
      subject_id = loan.subject_property.id
    when "Borrower"
      subject_id = loan.borrower.id
    when "Closing"
      subject_id = loan.closing.id
    when "Loan"
      subject_id = loan.id
    end
    subject_id
  end

  private

  def document_type_must_belong_to_proper_document
    case subject_name
    when "Property"
      return if Document::PROPERTY_LIST.include? document_type
    when "Borrower"
      return if Document::BORROWER_LIST.include? document_type
    when "Closing"
      return if Document::CLOSING_LIST.inclue? document_type
    when "Loan"
      return if Document::LOAN_LIST.include? document_type
    end
    errors.add(:document_type, "must belong to a proper document")
  end

  def subject_name_must_belong_to_proper_subject
    unless %w(Borrower Property Loan Closing).include? subject_name
      errors.add(:subject_name, "must belong to a proper subject")
    end
  end
end
