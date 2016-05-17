class RefinanceProposalMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"]
  def notify_refinance_benefit(benefit_info, user_name, user_email)
    @user_name = user_name
    @benefit_info = benefit_info

    mail(
      to: user_email,
      subject: "Re: Your mortgage with #{@benefit_info[:old_lender]}"
    )
  end
end
