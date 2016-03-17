class Admins::BorrowerManagementsController < Admins::BaseController
  def index
    bootstrap(borrowers: borrowers)

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def switch
    return unless current_user.admin?

    sign_in(:user, User.find(params[:id]), bypass: true)

    redirect_to my_loans_path
  end

  def destroy
    borrower = Borrower.find(params[:id])
    if borrower.destroy
      render json: {
        message: t("admins.borrower_managements.destroy.remove_success", borrower: borrower.to_s),
        borrowers: borrowers
      }, status: 200
    else
      render json: {message: t("admins.borrower_managements.destroy.remove_failed")}, status: 500
    end
  end

  def borrowers
    Admins::BorrowersPresenter.new(Borrower.all.includes(:user).joins(:user).order(User.arel_table[:last_name])).show
  end
end
