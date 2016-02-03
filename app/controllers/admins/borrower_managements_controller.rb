class Admins::BorrowerManagementsController < Admins::BaseController
  def index
    bootstrap(borrowers: Admins::BorrowersPresenter.new(Borrower.all.includes(:user)).show)

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def switch
    return unless current_user.admin?

    sign_in(:user, User.find(params[:id]), {bypass: true})

    redirect_to my_loans_path
  end
end
