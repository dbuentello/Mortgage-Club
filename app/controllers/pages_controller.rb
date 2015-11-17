class PagesController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!

  def index
    @refcode = params[:refcode]
    @mortgage_aprs = MortgageRateServices::GetMortgageAprs.call

    if @mortgage_aprs['updated_at'].present?
      @last_updated = Time.zone.parse(@mortgage_aprs['updated_at'].to_s).strftime('%b %d, %G %R%P %Z')
    end
  end

  def take_home_test
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

    render json: {rates: @rates}, status: 200
  end
end
