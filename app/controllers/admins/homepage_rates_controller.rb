class Admins::HomepageRatesController < Admins::BaseController
  def index
    homepage_rates = HomepageRate.today_rates
    if homepage_rates.blank?
      lender_names = ["Mortgage Club", "Wells Fargo", "Quicken Loans"]
      programs = ["15 Year Fixed", "5/1 Libor ARM", "30 Year Fixed"]
      lender_names.each do |lender|
        programs.each do |program|
          HomepageRate.create(lender_name: lender, program: program)
        end
      end
    end
    @today_rates = HomepageRate.today_rates

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  private

  def homepage_rate_params
    # params.require(:homepage_rate).permit(HomepageRate::PERMITTED_ATTRS)
  end
end