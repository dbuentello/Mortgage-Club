class Checklist < ActiveRecord::Base
  belongs_to :loan
  belongs_to :user
  belongs_to :template

  validates :name, :description, :loan_id, :user_id, :checklist_type, :status, presence: true
end