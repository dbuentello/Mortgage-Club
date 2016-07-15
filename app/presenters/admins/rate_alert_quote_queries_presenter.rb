class Admins::RateAlertQuoteQueriesPresenter
  def initialize(rate_alert_quote_queries)
    @rate_alert_quote_queries = rate_alert_quote_queries
  end

  def show
    @rate_alert_quote_queries.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :email, :first_name, :last_name, :code_id]
    }
  end
end
