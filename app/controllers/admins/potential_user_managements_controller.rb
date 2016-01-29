class Admins::PotentialUserManagementsController < Admins::BaseController
  before_action :set_potential_user, except: [:index]

  def index
    potential_users = PotentialUser.all

    bootstrap(
      potential_users: Admins::PotentialUsersPresenter.new(potential_users).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(
      potential_user: Admins::PotentialUserPresenter.new(@potential_user).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @potential_user.update(potential_user_params)
      render json: {potential_user: Admins::PotentialUserPresenter.new(@potential_user).show, message: 'Updated sucessfully'}, status: 200
    else
      render json: {message: "Updated failed"}, status: 500
    end
  end

  def destroy
    if @potential_user.destroy
      render json: {
        message: "Removed the #{@potential_user.to_s} successfully",
        potential_users: Admins::PotentialUsersPresenter.new(PotentialUser.all).show
      }, status: 200
    else
      render json: {message: "Cannot remove the checklist"}, status: 500
    end
  end

  private

  def potential_user_params
    params.require(:potential_user).permit(:email, :phone_number)
  end

  def set_potential_user
    @potential_user = PotentialUser.find(params[:id])
  end
end
