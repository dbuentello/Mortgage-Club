class PotentialUsersController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def new
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end

  def create
    @potential_user = PotentialUser.new(potential_params)
    if(@potential_user.save)
      render json: {message: "success"}
    else
      render json: {message: "error"}
    end
  end

  private

  def potential_params
    params.require(:potential_user).permit(PotentialUser::PERMITTED_ATTRS)
  end

end