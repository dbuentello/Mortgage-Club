module BorrowerServices
  class RemoveSecondaryBorrower
    def self.call(current_user, loan, borrower_type)
      case borrower_type
      when :borrower
        secondary_borrower = loan.secondary_borrower
      when :secondary_borrower
        secondary_borrower = current_user.borrower
      end

      if secondary_borrower
        loan.secondary_borrower = nil
        loan.save
        secondary_borrower.loan = nil
        secondary_borrower.save
        CoBorrowerMailer.notify_being_removed(loan.id, secondary_borrower.id).deliver_later
      end
    end
  end
end
