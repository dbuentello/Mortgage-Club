class RefinanceProposalMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"]
  def notify_refinance_benefit(benefit_info, user_name, user_email)
    @user_name = user_name
    @benefit_info = benefit_info
    savings_in_1_year = @benefit_info[:lower_rate_refinance][:savings_in_1_year]
    new_interest_rate = @benefit_info[:lower_rate_refinance][:new_interest_rate]
    original_term = @benefit_info[:original_term]

    mail(
      to: user_email,
      subject: "Refinance your Wells Fargo mortgage and save $#{savings_in_1_year}/year (new rate #{new_interest_rate}%, #{original_term}, no closing costs)"
    )
  end
end