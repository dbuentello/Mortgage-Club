class Admins::HomepageRatesController < Admins::BaseController
  before_action :set_homepage_rate, only: [:edit, :update, :destroy]

  def index
    HomepageRateServices::CreateTodayHomepageRates.call if HomepageRate.today_rates.empty?

    bootstrap(today_rates: HomepageRate.today_rates.order(:lender_name, :program))

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    bootstrap(homepage_rate: @homepage_rate)

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    if @homepage_rate.update(homepage_rate_params)
      render json: {}
    else
      render json: {message: @homepage_rate.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  private

  def set_homepage_rate
    @homepage_rate = HomepageRate.find(params[:id])
  end

  def homepage_rate_params
    params.permit(HomepageRate::PERMITTED_ATTRS)
  end
end
