class CoBorrowerMailer < ActionMailer::Base
  default from: ENV['EMAIL_SENDER']

  def notify_being_added(loan_id, params={})
    @loan = Loan.find loan_id
    @secondary_borrower = @loan.secondary_borrower

    @is_new_user = params[:is_new_user]
    @default_password = params[:default_password] if @is_new_user

    mail(
      to: @secondary_borrower.user.email,
      subject: "You have been added as secondary borrower by #{@loan.user}"
    )
  end

  def notify_being_removed(loan_id, secondary_borrower_id, params={})
    @loan = Loan.find loan_id
    @secondary_borrower = Borrower.find secondary_borrower_id

    mail(
      to: @secondary_borrower.user.email,
      subject: "You have been removed as secondary borrower by #{@loan.user}"
    )
  end

  def notify_being_leaving(loan_id, secondary_borrower_id, params={})
    @loan = Loan.find loan_id
    @secondary_borrower = Borrower.find secondary_borrower_id

    mail(
      to: @loan.user.email,
      subject: "Your co-borrower #{@secondary_borrower.user} has left your loan"
    )
  end
end
