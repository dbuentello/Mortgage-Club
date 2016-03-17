module LoanActivityServices
  class SetUserVisibleToFalse
    def self.call(loan, activity_name)
      LoanActivity.where(loan_id: loan.id, name: activity_name).update_all(user_visible: false)
    end
  end
end
