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
    potential_user = PotentialUser.new(potential_params)
    if potential_user.save
      PotentialUserMailer.inform_new_file_upload(potential_user).deliver_later
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