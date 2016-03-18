class Admins::PotentialRateDropUserManagementsController < Admins::BaseController
  before_action :set_potential_rate_drop_user, except: [:index]

  def index
    potential_rate_drop_users = PotentialRateDropUser.all

    bootstrap(
      potential_rate_drop_users: Admins::PotentialRateDropUsersPresenter.new(potential_rate_drop_users).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(
      potential_rate_drop_user: Admins::PotentialRateDropUserPresenter.new(@potential_rate_drop_user).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @potential_rate_drop_user.update(potential_rate_drop_user_params)
      render json: {potential_rate_drop_user: Admins::PotentialRateDropUserPresenter.new(@potential_rate_drop_user).show, message: 'Updated sucessfully'}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def destroy
    if @potential_rate_drop_user.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        potential_rate_drop_users: Admins::PotentialRateDropUsersPresenter.new(PotentialRateDropUser.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove"))}, status: 500
    end
  end

  private

  def potential_rate_drop_user_params
    params.require(:potential_rate_drop_user).permit(:email, :phone_number, :zip, :current_mortgage_rate, :current_mortgage_balance, :estimated_home_value, :credit_score, :refinance_purpose)
  end

  def set_potential_rate_drop_user
    @potential_rate_drop_user = PotentialRateDropUser.find(params[:id])
  end
end
