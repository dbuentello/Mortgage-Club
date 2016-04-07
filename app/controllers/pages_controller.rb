class PagesController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  before_action :set_mixpanel_token, only: [:index]

  def index
    @refcode = params[:refcode]
    @mortgage_aprs = HomepageRateServices::GetMortgageAprs.call

    if @mortgage_aprs['updated_at'].present?
      @last_updated = Time.zone.parse(@mortgage_aprs['updated_at'].to_s).strftime('%b %d, %G 8:30 AM %Z')
      @last_updated = @last_updated.gsub("PDT", "PST")
    end
  end

  def developer_infographics
  end

  def backend_test
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end

  def frontend_test
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end

  def home_test_rates
    if @rates = REDIS.get("rates_for_home_test")
      @rates = JSON.parse(@rates)
    else
      @rates = []
    end

    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "GET"

    render json: {rates: @rates}, status: 200
  end

  def slack_bot
  end

  def slack_bot_privacy
  end
end
