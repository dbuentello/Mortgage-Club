class InitialQuotesController < ApplicationController
  layout "landing"
  skip_before_action :authenticate_user!
  before_action :set_quote, only: [:set_rate_alert]
  skip_before_action :verify_authenticity_token, only: [:set_rate_alert]
  def index
    quote_cookies = get_quote_cookies

    bootstrap(
      zipcode: quote_cookies["zip_code"],
      credit_score: quote_cookies["credit_score"] || 740,
      property_value: quote_cookies["property_value"],
      down_payment: quote_cookies["down_payment"],
      mortgage_balance: quote_cookies["mortgage_balance"],
      mortgage_purpose: quote_cookies["mortgage_purpose"] || "refinance",
      property_usage: quote_cookies["property_usage"] || "primary_residence",
      property_type: quote_cookies["property_type"] || "sfh"
    )

    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
    cookies[:current_quote] = {value: quotes_params.to_json, expires: 30.minutes.from_now}
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

    bootstrap(
      code_id: quote_query.code_id,
      quotes: quotes,
      data_cookies: query,
      selected_programs: params[:program],
      monthly_payment: monthly_payment,
      user_role: current_user ? current_user.role_name : ""
    )

    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def set_rate_alert
    if @quote
      unless @quote.alert
        @quote.update_attribute(:alert, true)
        QuoteService.create_graph_quote(@quote)
      end
    end
    @rate_alert = RateAlertQuoteQuery.new(rate_alert_quote_params)
    @rate_alert.code_id = @quote.code_id
    @rate_alert.quote_query_id = @quote.id
    @rate_alert.save!
    render json: {success: true}, status: 200
  end

  def email_me
    ShareQuoteInfo.create(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], quote_link: "#{unauthenticated_root_url}quotes/#{params[:code_id]}")
    ShareRateMailer.email_me(params, current_user).deliver_now!
    render json: {success: true}, status: 200
  end

  def render_html
    @first_name = "[first_name]"
    @rate = params[:rate]
    @code = params[:code_id]

    quote = QuoteQuery.find_by_code_id(params[:code_id])
    @quote_query = JSON.load quote.query
    @current_user = current_user

    @prepaid_item_fees = @rate["thirty_fees"].find { |_key, value| value["Description"] == "Prepaid items" }.last["FeeAmount"]

    if current_user && current_user.has_role?(:loan_member)
      @email_from = current_user.email.present? ? "#{current_user} <#{current_user.email}>" : "Billy Tran <billy@mortgageclub.co>"
      @email = current_user.email.present? ? current_user.email : "billy@mortgageclub.co"
      @phone = current_user.loan_member.phone_number.present? ? current_user.loan_member.phone_number : "(650) 787-7799"
    else
      @email_from = "Billy Tran <billy@mortgageclub.co>"
      @email = "billy@mortgageclub.co"
      @phone = "(650) 787-7799"
    end

    purchase_template = render_to_string "share_rate_mailer/email_me", layout: false
    refinance_template = render_to_string "share_rate_mailer/refinance_rate_quote", layout: false

    render json: {purchase_template: purchase_template, refinance_template: refinance_template, is_purchase: @quote_query["mortgage_purpose"] == "purchase"}, status: 200
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
    return {} if cookies[:current_quote].nil?

    begin
      info = JSON.parse(cookies[:current_quote])
    rescue JSON::ParserError
      info = {}
    end

    info
  end

  def rate_alert_quote_params
    params.permit(:email, :first_name, :last_name)
  end

  def quotes_params
    params.permit(
      :zip_code,
      :credit_score,
      :mortgage_purpose,
      :property_value,
      :property_usage,
      :property_type,
      :down_payment,
      :mortgage_balance,
      :loan_amount,
      :lender_name,
      :lender_nmls_id,
      :amortization_type,
      :interest_rate,
      :period,
      :total_closing_cost,
      :lender_credits,
      :monthly_payment,
      :loan_type,
      :apr,
      :pmi_monthly_premium_amount,
      :lender_underwriting_fee,
      :appraisal_fee,
      :tax_certification_fee,
      :flood_certification_fee,
      :outside_signing_service_fee,
      :concurrent_loan_charge_fee,
      :endorsement_charge_fee,
      :lender_title_policy_fee,
      :recording_service_fee,
      :settlement_agent_fee,
      :recording_fees,
      :owner_title_policy_fee,
      :prepaid_item_fee,
      :prepaid_homeowners_insurance,
      :discount_pts,
      :cash_out
    )
  end
end
