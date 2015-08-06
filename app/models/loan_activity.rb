# == Schema Information
#
# Table name: loan_activities
#
#  id              :integer          not null, primary key
#  name            :string
#  activity_type   :integer          default(0), not null
#  activity_status :integer          default(0), not null
#  user_visible    :boolean          default(FALSE), not null
#  loan_id         :integer
#  loan_member_id  :integer
#  created_at      :datetime
#  updated_at      :datetime
#  started_at      :datetime
#  duration        :integer
#

class LoanActivity < ActiveRecord::Base
  LIST = {
    "Prior to Loan Submission" => ["Verify borrower's income", "Verify borrower's down payment", "Verify borrower's rental properties", "Other"],
    "Prior to Loan Docs" => ["Verify borrower's employment", "Ask borrower to submit additional documents"],
    "Prior to Closing" => ["Order preliminary title report", "Schedule notary appointment"],
    "Post Closing" => ["Review loan criteria per lender request"]
  }

  belongs_to :loan
  belongs_to :loan_member

  enum activity_type: {
    loan_submission: 0,
    loan_doc: 1,
    closing: 2,
    post_closing: 3
  }

  enum activity_status: {
    start: 0,
    done: 1,
    pause: 2
  }

  validates_presence_of :loan, :loan_member
  validates_inclusion_of :user_visible, in: [true, false]

  validates_uniqueness_of :name, uniqueness: true, scope: :loan_id
  validates_uniqueness_of :name, uniqueness: true, scope: :activity_type
end
