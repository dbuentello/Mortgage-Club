# == Schema Information
#
# Table name: pending_borrowers
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  loan_id    :integer
#  timestamps :string
#

class PendingBorrower < ActiveRecord::Base
  belongs_to :loan, inverse_of: :pending_secondary_borrower

  # NEED_TODO: add validations for name and email, also for loan association

end

