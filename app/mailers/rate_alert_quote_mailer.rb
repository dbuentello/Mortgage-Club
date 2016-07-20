class RateAlertQuoteMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper
  default from: ENV["EMAIL_SENDER"]

  def inform_quote_changed(user, new_graph, pre_graph)
    @rate_alert_user = user
    @new_graph = build_result(new_graph)
    @pre_graph =  build_result(pre_graph)
    mail(
      to: @rate_alert_user.email,
      subject: "Your quote has changed - MortgageClub"
    )
  end

  def build_result(graph)
    year30 = JSON.parse(graph.year30)
    year15 = JSON.parse(graph.year15)
    arm71 = JSON.parse(graph.arm71)
    arm51 = JSON.parse(graph.arm51)

    graph = {
      "year30": {
        "rate": year30["interest_rate"].to_f * 100,
        "lender_credit": number_to_currency(year30["lender_credits"])
      },
      "year15": {
        "rate": year15["interest_rate"].to_f * 100,
        "lender_credit": number_to_currency(year15["lender_credits"])
      },
      "arm71": {
        "rate": arm71["interest_rate"].to_f * 100,
        "lender_credit": number_to_currency(arm71["lender_credits"])
      },
      "arm51": {
        "rate": arm51["interest_rate"].to_f * 100,
        "lender_credit": number_to_currency(arm51["lender_credits"])
      }
    }
  end
end
