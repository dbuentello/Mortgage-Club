class PotentialUsersController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def new
    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
    potential_user = PotentialUser.new(potential_params)

    if potential_user.save
      render json: {message: "success"}
    else
      return render_error(potential_user)
    end
  end

  private

  def render_error(potential_user)
    render json: {
      email: "This field is required",
      mortgage_statement: "This field is required",
      alert_method: "This field is required"
    }, status: 500
  end

  def potential_params
    params.require(:potential_user).permit(PotentialUser::PERMITTED_ATTRS)
  end
end
