class RateAlertQuoteMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"]

  def inform_quote_changed(user, graph)
    @rate_alert_user = user
    @graph = graph
    mail(
      to: @rate_alert_user.email,
      subject: "Your quote has changed - MortgageClub"
    )
  end
end
