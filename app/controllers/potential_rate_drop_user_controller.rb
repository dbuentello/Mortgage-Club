class PotentialRateDropUserController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def new
    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
    byebug
    potential_rate_drop_user = PotentialRateDropUser.new(potential_rate_drop_params)

    if potential_rate_drop_user.save
      render json: {message: "success"}
    else
      return render_error(potential_rate_drop_user)
    end
  end

  private

  def render_error(potential_rate_drop_user)
    render json: {
      email: potential_rate_drop_user.errors[:email].present? ? "This field is required" : nil
      }, status: 500
  end

  def potential_rate_drop_params
    params.require(:potential_rate_drop_user).permit(PotentialRateDropUser::PERMITTED_ATTRS)
  end
end
