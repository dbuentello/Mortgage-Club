class Checklist < ActiveRecord::Base
  belongs_to :loan
  belongs_to :user
  belongs_to :template

  validates :name, :description, :loan_id, :user_id, :checklist_type, :status, presence: true

  def document
    document = self.document_type.constantize.new
    {
      label: document.label_name,
      upload_path: document.upload_path,
      subject_key_name: document.subject_key_name,
      subject_name: document.subject_name
    }
  end
end