class LeadRequest < ActiveRecord::Base
  belongs_to :loan
  belongs_to :loan_member

  scope :sent, -> { where(status: "sent") }

  enum status: {
    new_request: 0,
    sent: 1
  }
end
