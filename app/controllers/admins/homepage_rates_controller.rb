class Admins::HomepageRatesController < Admins::BaseController
  before_action :set_homepage_rate, only: [:edit, :update, :destroy]
  def index
    today_rates = HomepageRate.today_rates
    if today_rates.blank?
      lender_names = ["Mortgage Club", "Wells Fargo", "Quicken Loans"]
      programs = ["15 Year Fixed", "5/1 Libor ARM", "30 Year Fixed"]
      lender_names.each do |lender|
        programs.each do |program|
          HomepageRate.create(lender_name: lender, program: program)
        end
      end
    end
    today_rates = HomepageRate.today_rates
    bootstrap(today_rates: today_rates)

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(homepage_rate: @homepage_rate)

    respond_to do |format|
      format.html { render template: 'admin_app' }
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