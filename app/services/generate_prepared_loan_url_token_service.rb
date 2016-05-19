class GeneratePreparedLoanUrlTokenService
  def self.call(loan)
    host_name = ENV.fetch("HOST_NAME", "localhost:4000")

    token, enc = Devise.token_generator.generate("User".constantize, :reset_password_token)
    loan.user.reset_password_token   = enc
    loan.user.reset_password_sent_at = Time.zone.now.utc
    loan.user.save(validate: false)
    loan.update(prepared_loan_token: token)

    Rails.application.routes.url_helpers.edit_user_password_url(reset_password_token: token, host: host_name)
  end
end