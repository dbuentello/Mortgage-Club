# == Schema Information
#
# Table name: loan_activities
#
#  id              :integer          not null, primary key
#  name            :string
#  activity_type   :integer
#  activity_status :integer
#  user_visible    :boolean
#  loan_id         :integer
#  loan_member_id  :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class LoanActivity < ActiveRecord::Base
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

end
