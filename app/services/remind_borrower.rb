class RemindBorrower
  def self.call
    loans = Loan.all

    loans.each do |loan|
      checklists = loan.checklists.where(status: "pending")
      next unless checklists.present?

      RemindBorrowerMailer.remind_checklists(loan).deliver_later
    end
  end

  def self.remind_with_loan_id(loan_id)
    loan = Loan.find(loan_id)
    checklists = loan.checklists.where(status: "pending")
    return unless checklists.present?

    RemindBorrowerMailer.remind_checklists(loan).deliver_later
  end
end
