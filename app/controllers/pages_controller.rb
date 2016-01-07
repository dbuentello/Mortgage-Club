class PagesController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!

  def index
    @refcode = params[:refcode]
    @mortgage_aprs = MortgageRateServices::GetMortgageAprs.call

    if @mortgage_aprs['updated_at'].present?
      @last_updated = Time.zone.parse(@mortgage_aprs['updated_at'].to_s).in_time_zone("Pacific Time (US & Canada)").strftime('%b %d, %G %R %Z')
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
end
