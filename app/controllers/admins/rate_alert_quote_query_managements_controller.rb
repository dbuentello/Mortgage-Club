class Admins::RateAlertQuoteQueryManagementsController < Admins::BaseController
  def index
    rate_alert_quote_queries = RateAlertQuoteQuery.all

    bootstrap(
      rate_alert_quote_queries: Admins::RateAlertQuoteQueriesPresenter.new(rate_alert_quote_queries).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end
end
