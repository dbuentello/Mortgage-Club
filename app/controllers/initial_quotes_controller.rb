class InitialQuotesController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def index
    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
    cache_key = "initial_quotes"

    if quotes = REDIS.get(cache_key)
      quotes = JSON.parse(quotes)
    else
      quotes = LoanTekServices::GetInitialQuotes.new(quotes_params).call
      REDIS.set(cache_key, quotes.to_json)
      REDIS.expire(cache_key, 30.hours.to_i)
    end

    render json: {quotes: quotes}
  end

  def save_info
    cookies[:initial_quotes] = {value: quotes_params.to_json, expires: 7.days.from_now}

    render json: {success: true}
  end

  private

  def quotes_params
    params.permit(:zip_code, :credit_score, :mortgage_purpose, :property_value, :property_usage, :property_type)
  end
end
