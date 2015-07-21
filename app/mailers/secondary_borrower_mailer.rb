class SecondaryBorrowerMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def notify_being_added(loan_id, params={})
    @loan = Loan.find loan_id
    @secondary_borrower = @loan.secondary_borrower

    @is_new_user = params[:is_new_user] || false
    if @is_new_user
      @default_password = params[:default_password]
    end

    mail(
      to: @secondary_borrower.user.email,
      subject: "You have been added as secondary borrower from #{@loan.user.to_s}"
    )
  end

  def notify_being_removed(loan_id, secondary_borrower_id, params={})
    @loan = Loan.find loan_id
    @secondary_borrower = Borrower.find secondary_borrower_id

    mail(
      to: @secondary_borrower.user.email,
      subject: "You have been removed as secondary borrower from #{@loan.user.to_s}"
    )
  end

end