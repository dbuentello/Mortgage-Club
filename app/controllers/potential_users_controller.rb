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
      email: potential_user.errors[:email].try(:first),
      mortgage_statement: potential_user.errors[:mortgage_statement].try(:first),
      alert_method: potential_user.errors[:alert_method].try(:first)
    }, status: 500
  end

  def potential_params
    params.require(:potential_user).permit(PotentialUser::PERMITTED_ATTRS)
  end
end
