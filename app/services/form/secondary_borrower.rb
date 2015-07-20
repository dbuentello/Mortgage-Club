module Form
  class SecondaryBorrower
    def self.check_existing_borrower(current_user, borrower_email)
      user = User.where(email: borrower_email).first

      if user.present? && user != current_user
        return true
      else
        return false
      end

    end

    def self.save(current_user, params = {})
      borrower_params = params.except(:email)
      is_existing = check_existing_borrower(current_user, params[:email])

      if is_existing
        user = User.where(email: params[:email]).first
        borrower = user.borrower
        borrower.update(borrower_params)
      else
        # create user corresponding with the co-borrower info
        user = User.new(
          email: params[:email], password: '12345678', password_confirmation: '12345678',
          borrower_attributes: borrower_params
        )
        user.skip_confirmation!
        user.save
      end

      # link that new borrower as co-borrower of current loan
      loan = current_user.loans.first
      loan.secondary_borrower = user.borrower
      loan.save

      # send email to co-borrower to let him know
      # NEED_TODO
      # SecondaryBorrowerMailer.notify_being_added(loan.id).deliver_now
    end

  end
end
