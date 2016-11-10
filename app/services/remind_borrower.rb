class RemindBorrower
  def self.call
    loans = Loan.all

    loans.each do |loan|
      checklists = loan.checklists.where(status: "pending")
      next unless checklists.present?

      RemindBorrowerMailer.remind_checklists(loan).deliver_later
    end
  end
end
