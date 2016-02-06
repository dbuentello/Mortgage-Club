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
    display_time = Time.zone.parse(@homepage_rate.display_time.to_s).strftime('%Y-%m-%d %H:%M')

    bootstrap(homepage_rate: {
      id: @homepage_rate.id,
      rate_value: @homepage_rate.rate_value,
      lender_name: @homepage_rate.lender_name,
      program: @homepage_rate.program,
      display_time: display_time
    })

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    display_time = Time.zone.parse(homepage_rate_params[:display_time])

    if @homepage_rate.update(rate_value: homepage_rate_params[:rate_value], display_time: display_time)
      HomepageRate.today_rates.update_all(display_time: display_time)
      HomepageRateServices::GetMortgageAprs.delay.call(true)

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
