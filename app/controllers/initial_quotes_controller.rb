class InitialQuotesController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @refcode = params[:refcode]
    @mortgage_aprs = HomepageRateServices::GetMortgageAprs.call
    @last_updated = nil
    if @mortgage_aprs['updated_at'].present?
      @last_updated = Time.zone.parse(@mortgage_aprs['updated_at'].to_s).strftime('%b %d, %G %I:%M %p %Z')
      @last_updated = @last_updated.gsub("PDT", "PST")
    end

    quote_cookies = get_quote_cookies

    bootstrap(
      last_updated: @last_updated,
      refcode: @refcode,
      mortgage_aprs: @mortgage_aprs,
      zipcode: quote_cookies["zip_code"],
      credit_score: quote_cookies["credit_score"],
      property_value: quote_cookies["property_value"],
      mortgage_purpose: quote_cookies["mortgage_purpose"] || "purchase",
      property_usage: quote_cookies["property_usage"] || "primary_residence",
      property_type: quote_cookies["property_type"] || "sfh"
    )

    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
    quotes = LoanTekServices::GetInitialQuotes.new(quotes_params).call

    render json: {quotes: quotes}
  end

  def save_info
    cookies[:initial_quotes] = {value: quotes_params.to_json, expires: 7.days.from_now}

    render json: {success: true}
  end

  private

  def get_quote_cookies
    return {} if cookies[:initial_quotes].nil?

    begin
      info = JSON.parse(cookies[:initial_quotes])
    rescue JSON::ParserError
      info = {}
    end

    info
  end

  def quotes_params
    params.permit(:zip_code, :credit_score, :mortgage_purpose, :property_value, :property_usage, :property_type)
  end
end
