class InitialQuotesController < ApplicationController
  layout "landing"
  skip_before_action :authenticate_user!
  before_action :set_mixpanel_token, only: [:index]
  before_action :set_quote, only: [:set_rate_alert]
  skip_before_action :verify_authenticity_token, only: [:set_rate_alert]
  def index
    quote_cookies = get_quote_cookies

    bootstrap(
      zipcode: quote_cookies["zip_code"],
      credit_score: quote_cookies["credit_score"] || 740,
      property_value: quote_cookies["property_value"] || 500_000,
      down_payment: quote_cookies["down_payment"] || (500_000 * 0.2),
      mortgage_balance: quote_cookies["mortgage_balance"],
      mortgage_purpose: quote_cookies["mortgage_purpose"] || "purchase",
      property_usage: quote_cookies["property_usage"] || "primary_residence",
      property_type: quote_cookies["property_type"] || "sfh"
    )

    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
    quote_query = QuoteQuery.new(query: quotes_params.to_json)
    render json: {code_id: quote_query.code_id} if quote_query.save
  end

  def show
    quotes = []
    quote_query = QuoteQuery.find_by_code_id(params[:id])

    if quote_query
      begin
        query = JSON.parse(quote_query.query)
      rescue JSON::ParserError
        query = {}
      end
      quotes = LoanTekServices::GetInitialQuotes.new(query).call
      monthly_payment = ZillowService::GetMonthlyPayment.new(query).call
    end
    byebug
    bootstrap(
      code_id: quote_query.code_id,
      quotes: quotes,
      data_cookies: query,
      selected_programs: params[:program],
      monthly_payment: monthly_payment
    )

    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def set_rate_alert
    byebug
    @quotes = []
    if @quote
      begin
        query = JSON.parse(@quote.query)
      rescue JSON::ParserError
        query = {}
      end
      byebug
      @quotes = LoanTekServices::GetInitialQuotes.new(query).lowest_apr
    end

    # @quotes = LoanTekServices::GetInitialQuotes.new(@quote.query).call
    @rate_alert = RateAlertQuoteQuery.new(rate_alert_quote_params)
    @rate_alert.code_id = @quote.code_id
    @rate_alert.quote_query_id = @quote.id
    @rate_alert.save!
    render json: {success: true}, status: 200
  end

  def save_info
    cookies[:initial_quotes] = {value: quotes_params.to_json, expires: 7.days.from_now}

    render json: {success: true}
  end

  private

  def set_quote
    @quote = QuoteQuery.find_by_code_id(params[:code_id])
  end

  def get_quote_cookies
    return {} if cookies[:initial_quotes].nil?

    begin
      info = JSON.parse(cookies[:initial_quotes])
    rescue JSON::ParserError
      info = {}
    end

    info
  end

  def rate_alert_quote_params
    params.permit(:email, :first_name, :last_name)
  end

  def quotes_params
    params.permit(:zip_code, :credit_score, :mortgage_purpose, :property_value, :property_usage, :property_type, :down_payment, :mortgage_balance)
  end
end
